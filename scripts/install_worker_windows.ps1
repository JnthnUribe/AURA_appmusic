<#
.SYNOPSIS
    Install, start or remove the Aura ingestion worker as a Windows scheduled task.

.DESCRIPTION
    Registers a task that runs at logon in the current user's session:

        uv run python -m aura.worker

    The worker uses the repository's .env, needs ffmpeg and Deno on PATH, and
    opens no inbound ports. Run this script from an elevated or normal
    PowerShell; a per-user task does not require elevation.

.PARAMETER Uninstall
    Remove the scheduled task instead of creating it.

.PARAMETER TaskName
    Scheduled task name. Default: "Aura Worker".

.PARAMETER StartNow
    Start the task immediately after registration.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\install_worker_windows.ps1 -StartNow

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\install_worker_windows.ps1 -Uninstall
#>
[CmdletBinding()]
param(
    [switch]$Uninstall,
    [string]$TaskName = 'Aura Worker',
    [switch]$StartNow
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Backend = Join-Path $Root 'backend'
$EnvFile = Join-Path $Root '.env'

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Warn([string]$Message) {
    Write-Host "!!  $Message" -ForegroundColor Yellow
}

if ($Uninstall) {
    $existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        Write-Host "Task '$TaskName' is not installed."
        return
    }
    Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "Removed scheduled task '$TaskName'."
    return
}

if (-not (Test-Path $Backend)) {
    throw "Backend directory not found: $Backend"
}

$uv = Get-Command uv -ErrorAction SilentlyContinue
if ($null -eq $uv) {
    throw 'uv is not on PATH. Install it from https://docs.astral.sh/uv/ and retry.'
}

if (-not (Test-Path $EnvFile)) {
    Copy-Item (Join-Path $Root '.env.example') $EnvFile
    Write-Warn "Created $EnvFile from .env.example. Fill DATABASE_URL, R2_* and WORKER_TOKEN before starting."
}

foreach ($tool in @('ffmpeg', 'deno')) {
    if ($null -eq (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Warn "$tool is not on PATH. The worker will start but downloads may fail."
    }
}

Write-Step 'Syncing backend dependencies'
Push-Location $Backend
try {
    & $uv.Source sync
    if ($LASTEXITCODE -ne 0) {
        throw "uv sync failed with exit code $LASTEXITCODE"
    }
}
finally {
    Pop-Location
}

Write-Step "Registering scheduled task '$TaskName'"
$runner = Join-Path $PSScriptRoot 'run_worker.ps1'
$action = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$runner`"" `
    -WorkingDirectory $Backend

$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME

$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -RestartCount 5 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal `
    -UserId "$env:USERDOMAIN\$env:USERNAME" `
    -LogonType Interactive `
    -RunLevel Limited

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal `
    -Force | Out-Null

Write-Host "Installed '$TaskName'. It will start at your next logon."

if ($StartNow) {
    Write-Step 'Starting the worker now'
    Start-ScheduledTask -TaskName $TaskName
    Start-Sleep -Seconds 2
    Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName, State
    Write-Host "Output is appended to $Root\worker.log."
}

Write-Host ''
Write-Host 'Useful commands:'
Write-Host "  Get-ScheduledTask -TaskName '$TaskName'"
Write-Host "  Start-ScheduledTask -TaskName '$TaskName'"
Write-Host "  Stop-ScheduledTask -TaskName '$TaskName'"
Write-Host "  powershell -File scripts\install_worker_windows.ps1 -Uninstall"
