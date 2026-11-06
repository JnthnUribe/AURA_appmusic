import 'package:flutter/material.dart';

import '../core/design/tokens.dart';
import 'section_header.dart';

class HorizontalShelf extends StatelessWidget {
  const HorizontalShelf({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 210,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.symmetric(horizontal: AuraSpace.md),
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double height;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: padding,
            itemCount: itemCount,
            separatorBuilder: (_, _) => const SizedBox(width: AuraSpace.sm),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
