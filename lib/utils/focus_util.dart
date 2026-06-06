import 'package:flutter/material.dart';

/// 收起键盘并清除焦点（从详情返回后避免输入框/选择框仍呈选中态）。
void clearScreenFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}
