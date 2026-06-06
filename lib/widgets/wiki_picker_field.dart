import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_layout.dart';
import '../theme/app_text_styles.dart';
import '../utils/focus_util.dart';

class WikiPickerOption<T> {
  const WikiPickerOption({required this.value, required this.label});

  final T? value;
  final String label;
}

class _PickerDone<T> {
  const _PickerDone(this.value);
  final T? value;
}

/// 带外置标题的选择行（与 [FilterIconRow] 排版一致）。
class FilterPickerRow<T> extends StatelessWidget {
  const FilterPickerRow({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintWhenNull,
    this.searchable = false,
    this.sheetTitle,
  });

  final String label;
  final T? value;
  final List<WikiPickerOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? hintWhenNull;
  final bool searchable;
  final String? sheetTitle;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: WikiPickerField<T>(
              value: value,
              options: options,
              onChanged: onChanged,
              hintWhenNull: hintWhenNull,
              searchable: searchable,
              sheetTitle: sheetTitle ?? label,
            ),
          ),
        ],
      ),
    );
  }
}

/// 点击字段 → 固定高度底部列表（不可拖拽上拉）。
class WikiPickerField<T> extends StatelessWidget {
  const WikiPickerField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintWhenNull,
    this.searchable = false,
    this.sheetTitle,
  });

  final T? value;
  final List<WikiPickerOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? hintWhenNull;
  final bool searchable;
  final String? sheetTitle;

  String get _displayLabel {
    for (final o in options) {
      if (o.value == value) return o.label;
    }
    return hintWhenNull ?? '请选择';
  }

  Future<void> _open(BuildContext context) async {
    clearScreenFocus();
    final done = await showModalBottomSheet<_PickerDone<T>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder: (ctx) => _WikiPickerSheet<T>(
        title: sheetTitle ?? '请选择',
        options: options,
        current: value,
        searchable: searchable,
      ),
    );
    clearScreenFocus();
    if (!context.mounted || done == null) return;
    onChanged(done.value);
  }

  @override
  Widget build(BuildContext context) {
    final fill =
        Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.gold.withValues(alpha: 0.2),
        highlightColor: AppColors.gold.withValues(alpha: 0.12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.85),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayLabel,
                  style: TextStyle(
                    fontSize: AppLayout.listSubtitleSize,
                    color: value == null
                        ? AppColors.textHint
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.unfold_more_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WikiPickerSheet<T> extends StatefulWidget {
  const _WikiPickerSheet({
    required this.title,
    required this.options,
    required this.current,
    required this.searchable,
  });

  final String title;
  final List<WikiPickerOption<T>> options;
  final T? current;
  final bool searchable;

  @override
  State<_WikiPickerSheet<T>> createState() => _WikiPickerSheetState<T>();
}

class _WikiPickerSheetState<T> extends State<_WikiPickerSheet<T>> {
  String _query = '';
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  void _pick(T? value) {
    clearScreenFocus();
    Navigator.pop(context, _PickerDone(value));
  }

  void _dismiss() {
    clearScreenFocus();
    Navigator.pop(context);
  }

  List<WikiPickerOption<T>> get _visible {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.options;
    return widget.options
        .where((o) => o.label.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    // 统一高度：略高于原分类弹框（0.46），食材/分类一致
    final sheetH = MediaQuery.sizeOf(context).height * 0.50;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: sheetH,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(
              top: BorderSide(color: AppColors.gold, width: 2),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyles.sectionTitle(),
                      ),
                    ),
                    IconButton(
                      onPressed: _dismiss,
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              if (widget.searchable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    focusNode: _searchFocus,
                    decoration: const InputDecoration(
                      hintText: '搜索选项…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              Expanded(
                child: _visible.isEmpty
                    ? Center(
                        child: Text(
                          '无匹配项',
                          style: TextStyle(color: AppColors.textHint),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                        itemCount: _visible.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: AppColors.gold.withValues(alpha: 0.35),
                        ),
                        itemBuilder: (context, i) {
                          final opt = _visible[i];
                          final selected = opt.value == widget.current;
                          return Material(
                            color: selected
                                ? AppColors.gold.withValues(alpha: 0.28)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: selected
                                    ? const BorderSide(
                                        color: AppColors.gold,
                                        width: 1.5,
                                      )
                                    : BorderSide.none,
                              ),
                              title: Text(
                                opt.label,
                                style: TextStyle(
                                  fontSize: AppLayout.listSubtitleSize,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              trailing: selected
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.textPrimary,
                                      size: 22,
                                    )
                                  : null,
                              onTap: () => _pick(opt.value),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
