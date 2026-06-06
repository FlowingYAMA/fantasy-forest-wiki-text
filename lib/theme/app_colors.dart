import 'package:flutter/material.dart';

/// 空想森林攻略 · 品牌色板（主色）+ 辅助色可按场景选用。
class AppColors {
  AppColors._();

  static const cream = Color(0xFFFFEEAD);
  static const gold = Color(0xFFFFCC5C);
  static const green = Color(0xFF96CEB4);
  static const greenLight = Color(0xFFAAD8B0);
  static const coral = Color(0xFFFF6F69);

  static const background = Color(0xFFFFF9EE);
  static const surface = cream;
  static const surfaceMuted = Color(0xFFFFF3D4);
  /// 图片框 / 占位默认底（暖米杏，替代偏绿的浅底）
  static const surfaceInset = Color(0xFFFFF5E6);

  /// 深棕文字（配奶油黄底）：主文 / 次要 / 提示
  static const textPrimary = Color(0xFF3D2914);
  static const textSecondary = Color(0xFF6B4A2E);
  static const textHint = Color(0xFF9A7A5C);

  /// 底栏当前项背景（暖金，替代绿色块）
  static final navIndicatorFill = gold.withValues(alpha: 0.52);

  /// 「全部」筛选：暖金米色，与四元素浅色并列
  static const filterAllTint = Color(0xFFFFF3DC);

  /// 法阵/元素筛选芯片底色（中文：全部、水、火、风、土）
  static Color filterChipTintForLabel(String label) {
    switch (label) {
      case '全部':
        return filterAllTint;
      case '水':
        return elementTint('water');
      case '火':
        return elementTint('fire');
      case '风':
        return elementTint('wind');
      case '土':
        return elementTint('soil');
      default:
        return surfaceInset;
    }
  }

  /// 选中时略向金黄靠拢，仍保留元素色相
  static Color filterChipTintSelected(String label) {
    return Color.lerp(filterChipTintForLabel(label), gold, 0.22)!;
  }

  /// 元素极浅底色（法阵列表/详情外框，尽量贴近页面底）
  static Color elementTint(String? elementKey) {
    switch (elementKey) {
      case 'water':
        return const Color(0xFFF8FCFE);
      case 'fire':
        return const Color(0xFFFFFAF9);
      case 'wind':
        return const Color(0xFFFAFCFA);
      case 'soil':
        return const Color(0xFFFFFCF6);
      default:
        return background;
    }
  }

}
