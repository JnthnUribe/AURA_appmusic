import 'package:flutter/material.dart';

import 'animated_gradient_background.dart';

class AuraScaffold extends StatelessWidget {
  const AuraScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.gradient = true,
    this.gradientColors,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool gradient;
  final List<Color>? gradientColors;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (gradient)
          AnimatedGradientBackground(colors: gradientColors),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
      ],
    );
  }
}
