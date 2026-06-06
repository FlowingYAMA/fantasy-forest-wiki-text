/// 全局布局常量（列表缩略图统一尺寸等）。
class AppLayout {
  AppLayout._();

  /// 食谱 / 法阵 / 材料 主页列表左侧图（正方形边长）。
  static const listThumbnailSize = 96.0;

  static const listThumbnailInset = 5.0;

  /// 法阵列表图内边距（略大，避免连线贴边）。
  static const magicListDiagramInset = 6.0;

  // —— 字号（随列表图放大一并提高）——
  static const listTitleSize = 17.0;
  static const listSubtitleSize = 15.0;
  static const listCaptionSize = 13.0;

  static const filterLabelSize = 14.0;
  static const filterChipPadding = 6.0;
  static const filterRowHeight = 56.0;

  /// 筛选芯片内图标边长（与行高、内边距联动，避免框大图标小）
  static double filterChipIconSizeFor({
    double rowHeight = filterRowHeight,
    double padding = filterChipPadding,
  }) =>
      rowHeight - 2 * padding - 4;

  static double get filterChipIconSize =>
      filterChipIconSizeFor();

  /// 食谱主页：种族 / 烹饪方式筛选（略大）
  static const dishFilterRowHeight = 62.0;
  static const dishFilterChipPadding = 7.0;
  static double get dishFilterChipIconSize => filterChipIconSizeFor(
        rowHeight: dishFilterRowHeight,
        padding: dishFilterChipPadding,
      );

  static const navLabelSize = 13.0;
  static const appBarTitleSize = 18.0;

  /// 食谱详情：种族 / 烹饪方式图标
  static const dishMetaIconSize = 68.0;
  static const dishMetaLabelSize = 14.0;

  /// 食谱详情：主料 / 辅料名称
  static const ingredientLabelSize = 13.0;
}
