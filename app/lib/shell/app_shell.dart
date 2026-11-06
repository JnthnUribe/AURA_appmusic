import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design/tokens.dart';
import '../core/l10n/l10n.dart';
import '../features/player/mini_player.dart';
import '../components/glass_surface.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.auraColors;
    return Scaffold(
      extendBody: true,
      backgroundColor: colors.background,
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AuraSpace.sm,
                0,
                AuraSpace.sm,
                AuraSpace.xs,
              ),
              child: GlassSurface(
                borderRadius: BorderRadius.circular(AuraRadius.lg),
                child: SizedBox(
                  height: 58,
                  child: Row(
                    children: [
                      _tab(
                        context,
                        index: 0,
                        icon: Icons.library_music_outlined,
                        activeIcon: Icons.library_music_rounded,
                        label: context.l10n.tabLibrary,
                      ),
                      _tab(
                        context,
                        index: 1,
                        icon: CupertinoIcons.search,
                        activeIcon: Icons.search_rounded,
                        label: context.l10n.tabSearch,
                      ),
                      _tab(
                        context,
                        index: 2,
                        icon: CupertinoIcons.settings,
                        activeIcon: CupertinoIcons.settings_solid,                        label: context.l10n.tabSettings,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final colors = context.auraColors;
    final active = navigationShell.currentIndex == index;
    return Expanded(
      child: Semantics(
        selected: active,
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                active ? activeIcon : icon,
                size: 24,
                color: active ? colors.accent : colors.textTertiary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AuraType.caption.copyWith(
                  fontSize: 10,
                  color: active ? colors.accent : colors.textTertiary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
