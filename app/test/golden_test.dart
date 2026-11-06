import 'dart:io';

import 'package:aura/features/auth/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_harness.dart';

/// Goldens are generated on Windows (the reference desktop target). Text
/// rasterization differs between host platforms, so the test is skipped
/// elsewhere instead of producing false regressions in CI.
void main() {
  setUpAll(() async {
    final data = await rootBundle.load('assets/fonts/Inter-Variable.ttf');
    final loader = FontLoader('Inter')
      ..addFont(Future.value(ByteData.view(data.buffer)));
    await loader.load();
    await _loadMaterialIcons();
  });

  testWidgets(
    'login screen matches the design baseline',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(testApp(child: const LoginScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_screen.png'),
      );
    },
    skip: !Platform.isWindows,
  );
}

Future<void> _loadMaterialIcons() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final file = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (!file.existsSync()) return;
  final bytes = await file.readAsBytes();
  final loader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}
