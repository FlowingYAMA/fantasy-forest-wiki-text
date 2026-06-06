import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_layout.dart';

/// 与 [AppLayout] 字号配套的常用文字样式。
class AppTextStyles {
  AppTextStyles._();

  static TextStyle listTitle({Color? color}) => TextStyle(
        fontSize: AppLayout.listTitleSize,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle listSubtitle({Color? color}) => TextStyle(
        fontSize: AppLayout.listSubtitleSize,
        height: 1.3,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle listCaption({Color? color}) => TextStyle(
        fontSize: AppLayout.listCaptionSize,
        height: 1.3,
        color: color ?? AppColors.textHint,
      );

  static TextStyle filterSectionLabel({Color? color}) => TextStyle(
        fontSize: AppLayout.filterLabelSize,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle sectionTitle({Color? color}) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );
}
