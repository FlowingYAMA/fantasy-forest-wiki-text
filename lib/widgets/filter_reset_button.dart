import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_layout.dart';

/// 清空当前页的搜索与筛选（需由页面自行实现 [onReset]）。
class FilterResetButton extends StatelessWidget {
  const FilterResetButton({
    super.key,
    required this.visible,
    required this.onReset,
  });

  final bool visible;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 8, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt_rounded, size: 18),
          label: const Text('重置'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            textStyle: TextStyle(fontSize: AppLayout.listCaptionSize),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      ),
    );
  }
}
