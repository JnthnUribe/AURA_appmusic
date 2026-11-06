import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/aura_scaffold.dart';
import '../../components/glass_surface.dart';
import '../../components/segmented_control.dart';
import '../../components/toast.dart';
import '../../core/design/tokens.dart';
import '../../core/l10n/l10n.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../auth/auth_controller.dart';
import '../library/library_providers.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.auraColors;
    final settings = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);
    final auth = ref.watch(authControllerProvider);
    final user = auth is AuthSignedIn ? auth.user : null;
    final tracks = ref.watch(tracksProvider).value ?? const [];
    final config = ref.watch(appConfigProvider);

    return AuraScaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AuraSpace.md,
            0,
            AuraSpace.md,
            200,
          ),
          children: [
            const SizedBox(height: AuraSpace.xs),
            Text(
              context.l10n.settingsTitle,
              style: AuraType.largeTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AuraSpace.lg),
            GlassSurface(
              borderRadius: BorderRadius.circular(AuraRadius.xl),
              padding: const EdgeInsets.all(AuraSpace.md),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: colors.accentSoft,
                    child: Text(
                      initials(user?.displayName ?? user?.email ?? 'A'),
                      style: AuraType.headline.copyWith(color: colors.accent),
                    ),
                  ),
                  const SizedBox(width: AuraSpace.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? context.l10n.account,
                          style: AuraType.headline.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AuraType.footnote.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.signOut,
                    onPressed: () => _confirmSignOut(context, ref),
                    icon: Icon(
                      Icons.logout_rounded,
                      color: colors.textSecondary,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AuraSpace.xl),
            _SectionTitle(context.l10n.theme),
            SegmentedControl<ThemeMode>(
              value: settings.themeMode,
              onChanged: settingsController.setThemeMode,
              items: [
                SegmentItem(
                  value: ThemeMode.system,
                  label: context.l10n.themeSystem,
                ),
                SegmentItem(
                  value: ThemeMode.dark,
                  label: context.l10n.themeDark,
                ),
                SegmentItem(
                  value: ThemeMode.light,
                  label: context.l10n.themeLight,
                ),
              ],
            ),
            const SizedBox(height: AuraSpace.xl),
            _SectionTitle(context.l10n.audio),
            _SettingsCard(
              children: [
                SwitchListTile.adaptive(
                  value: settings.normalizeVolume,
                  onChanged: settingsController.setNormalizeVolume,
                  title: Text(
                    context.l10n.normalizeVolume,
                    style: AuraType.callout,
                  ),
                  subtitle: Text(
                    'ReplayGain',
                    style: AuraType.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  secondary: const Icon(Icons.graphic_eq_rounded),
                ),
                Divider(color: colors.divider, height: 1),
                SwitchListTile.adaptive(
                  value: settings.wifiOnlyDownloads,
                  onChanged: settingsController.setWifiOnlyDownloads,
                  title: Text(
                    context.l10n.downloadsOnlyWifi,
                    style: AuraType.callout,
                  ),
                  secondary: const Icon(Icons.wifi_rounded),
                ),
              ],
            ),
            const SizedBox(height: AuraSpace.xl),
            _SectionTitle(context.l10n.storage),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.offline_pin_outlined),
                  title: Text(
                    context.l10n.tracksCount(tracks.length),
                    style: AuraType.callout,
                  ),
                  subtitle: Text(
                    'SQLite · Drift',
                    style: AuraType.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                Divider(color: colors.divider, height: 1),
                ListTile(
                  leading: Icon(Icons.delete_outline_rounded, color: colors.danger),
                  title: Text(
                    context.l10n.clearCache,
                    style: AuraType.callout.copyWith(color: colors.danger),
                  ),
                  onTap: () => _confirmClearCache(context, ref),
                ),
              ],
            ),
            const SizedBox(height: AuraSpace.xl),
            _SectionTitle(context.l10n.version),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_outlined),
                  title: Text('API', style: AuraType.callout),
                  subtitle: Text(
                    config.apiBaseUrl,
                    style: AuraType.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                if (config.enableDevGallery) ...[
                  Divider(color: colors.divider, height: 1),
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: Text(
                      context.l10n.designSystem,
                      style: AuraType.callout,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/gallery'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AuraSpace.lg),
            Text(
              'Aura 1.0.0 · ${config.environment}',
              textAlign: TextAlign.center,
              style: AuraType.caption.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.signOut, style: AuraType.headline),
        content: Text(
          context.l10n.account,
          style: AuraType.callout.copyWith(
            color: context.auraColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  Future<void> _confirmClearCache(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.clearCache, style: AuraType.headline),
        content: Text(
          context.l10n.emptyLibraryHint,
          style: AuraType.callout.copyWith(
            color: context.auraColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.clearCache),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(libraryRepositoryProvider).clearCache();
    if (context.mounted) {
      AuraToast.show(context, context.l10n.clearCache);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AuraSpace.xxs,
        bottom: AuraSpace.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: AuraType.caption.copyWith(
          color: context.auraColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      borderRadius: BorderRadius.circular(AuraRadius.lg),
      child: Column(children: children),
    );
  }
}
