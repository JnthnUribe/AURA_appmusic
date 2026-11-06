# Runs the Aura worker and appends output to worker.log.
# Used by the "Aura Worker" scheduled task (install_worker_windows.ps1).
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Backend = Join-Path $Root 'backend'
$Log = Join-Path $Root 'worker.log'

Set-Location $Backend
Write-Output "[$(Get-Date -Format o)] starting Aura worker" | Out-File -FilePath $Log -Append -Encoding utf8
& uv run python -m aura.worker *>> $Log
