import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_layout.dart';
import 'text_badge.dart';

class ItemIconTile extends StatelessWidget {
  const ItemIconTile({
    super.key,
    required this.label,
    this.icon,
    this.glyph,
    this.size = 48,
    this.framed = true,
    this.labelFontSize,
    this.cellWidth,
    this.backgroundColor,
  });

  final String label;
  final IconData? icon;
  final String? glyph;
  final double size;
  final bool framed;
  final double? labelFontSize;
  final double? cellWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final w = cellWidth ?? (size + 8);
    return SizedBox(
      width: w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBadge(
            label: label,
            size: size,
            icon: icon,
            glyph: glyph,
            framed: framed,
            backgroundColor: backgroundColor,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: labelFontSize ?? AppLayout.ingredientLabelSize,
              height: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
