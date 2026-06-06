import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 品牌色标签，与业务模块对应，不绑定具体口味等字段值。
enum AppTagStyle {
  /// 主色模块（调料、酱料形态等）
  cream,
  /// 种族 / 食材类
  green,
  /// 口味、次要信息
  greenLight,
  /// 烹饪方式、法阵等强调模块
  coral,
}

class AppTag extends StatelessWidget {
  const AppTag({
    super.key,
    required this.label,
    this.style = AppTagStyle.greenLight,
  });

  final String label;
  final AppTagStyle style;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  (Color bg, Color fg, Color border) _colors() {
    switch (style) {
      case AppTagStyle.cream:
        return (AppColors.cream, AppColors.textPrimary, AppColors.gold);
      case AppTagStyle.green:
        return (AppColors.green, AppColors.textPrimary, AppColors.gold);
      case AppTagStyle.greenLight:
        return (
          AppColors.greenLight,
          AppColors.textPrimary,
          AppColors.gold.withValues(alpha: 0.7),
        );
      case AppTagStyle.coral:
        return (AppColors.coral, Colors.white, AppColors.gold);
    }
  }
}
