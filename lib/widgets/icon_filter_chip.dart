import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_layout.dart';

class IconFilterChip extends StatelessWidget {
  const IconFilterChip({
    super.key,
    required this.selected,
    required this.onTap,
    this.label,
    this.icon,
    this.glyph,
    this.backgroundColor,
    this.padding = AppLayout.filterChipPadding,
    this.rowHeight = AppLayout.filterRowHeight,
    this.labelFontSize,
  });

  final bool selected;
  final VoidCallback onTap;
  final String? label;
  final IconData? icon;
  /// 无 [icon] 时在芯片内显示的单字（如种族「人马」为「马」）。
  final String? glyph;
  final Color? backgroundColor;
  final double padding;
  final double rowHeight;
  final double? labelFontSize;

  @override
  Widget build(BuildContext context) {
    final base = backgroundColor ?? AppColors.surfaceInset;
    final fill = selected ? Color.lerp(base, AppColors.gold, 0.22)! : base;
    final iconSide = AppLayout.filterChipIconSizeFor(
      rowHeight: rowHeight,
      padding: padding,
    );

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: label != null ? padding + 4 : padding,
            vertical: padding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.gold
                  : AppColors.gold.withValues(alpha: 0.65),
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: iconSide * 0.85,
                  color: AppColors.textPrimary,
                )
              else if (glyph != null)
                Text(
                  glyph!,
                  style: TextStyle(
                    fontSize: iconSide * 0.72,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
              else if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: labelFontSize ?? AppLayout.listSubtitleSize,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
