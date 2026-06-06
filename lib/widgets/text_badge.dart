import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 无图时用首字或 [icon] 显示在方框内。
class TextBadge extends StatelessWidget {
  const TextBadge({
    super.key,
    required this.label,
    this.size = 48,
    this.icon,
    this.glyph,
    this.backgroundColor,
    this.framed = true,
  });

  final String label;
  final double size;
  final IconData? icon;
  /// 无 [icon] 时优先显示的字（如种族「人马」显示「马」）。
  final String? glyph;
  final Color? backgroundColor;
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.surfaceInset;
    final displayGlyph = glyph ??
        (label.isNotEmpty ? label.characters.first : '?');
    final inner = icon != null
        ? Icon(icon, size: size * 0.48, color: AppColors.textPrimary)
        : Text(
            displayGlyph,
            style: TextStyle(
              fontSize: size * 0.36,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          );

    if (!framed) {
      return SizedBox(width: size, height: size, child: Center(child: inner));
    }

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.85),
            width: 1.5,
          ),
        ),
        child: Center(child: inner),
      ),
    );
  }
}
