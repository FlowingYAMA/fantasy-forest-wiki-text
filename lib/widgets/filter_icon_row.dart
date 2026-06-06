import 'package:flutter/material.dart';
import '../theme/app_layout.dart';
import '../theme/app_text_styles.dart';
import 'icon_filter_chip.dart';

/// 左对齐、单行横向滚动的图标筛选行（避免 Wrap 尾行只剩一个）。
class FilterIconRow extends StatelessWidget {
  const FilterIconRow({
    super.key,
    required this.label,
    required this.chips,
    this.rowHeight = AppLayout.filterRowHeight,
  });

  final String label;
  final List<IconFilterChip> chips;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: AppTextStyles.filterSectionLabel()),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: rowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => chips[i],
            ),
          ),
        ],
      ),
    );
  }
}
