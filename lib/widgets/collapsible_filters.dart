import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// 可收起的筛选区，减少列表被挡住的面积。
class CollapsibleFilters extends StatelessWidget {
  const CollapsibleFilters({
    super.key,
    required this.children,
    this.title = '筛选',
    this.initiallyExpanded = false,
    this.controller,
  });

  final List<Widget> children;
  final String title;
  final bool initiallyExpanded;
  final ExpansionTileController? controller;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controller: controller,
      initiallyExpanded: initiallyExpanded,
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.only(bottom: 8),
      title: Text(
        title,
        style: AppTextStyles.filterSectionLabel().copyWith(fontSize: 15),
      ),
      children: children,
    );
  }
}
