import 'package:flutter/material.dart';
import '../../data/wiki_repository.dart';
import '../../theme/app_layout.dart';
import '../../widgets/collapsible_filters.dart';
import '../../widgets/filter_icon_row.dart';
import '../../widgets/icon_filter_chip.dart';
import '../../widgets/text_badge.dart';
import 'alchemy_detail_screen.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/wiki_list_row.dart';
import '../../utils/focus_util.dart';
import '../../widgets/filter_reset_button.dart';
import '../../widgets/wiki_picker_field.dart';
import 'food_ingredient_detail_screen.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key, required this.kind});

  final String kind;

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _filtered = [];
  String _query = '';
  String? _classification;
  String? _taste;
  String? _typeFilter;
  List<String> _classOptions = [];
  List<String> _tasteOptions = [];
  final FocusNode _searchFocus = FocusNode();
  final ExpansionTileController _filtersController = ExpansionTileController();
  late final TextEditingController _searchController;

  static const _foodTypeOptions = ['食材', '调料'];

  bool get _hasActiveFilters {
    if (_query.trim().isNotEmpty) return true;
    if (widget.kind != 'food') return false;
    return _classification != null || _taste != null || _typeFilter != null;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _query = '';
      _searchController.clear();
      if (widget.kind == 'food') {
        _classification = null;
        _taste = null;
        _typeFilter = null;
      }
      _apply();
    });
    clearScreenFocus();
  }

  Future<void> _load() async {
    final repo = WikiRepository.instance;
    final meta = await repo.meta();
    final list = widget.kind == 'food'
        ? await repo.foodIngredients()
        : await repo.alchemyIngredients();

    final classFromMeta = (meta['ingredientClassifications'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final tasteFromMeta =
        (meta['ingredientTastes'] as List?)?.cast<String>() ?? [];

    setState(() {
      _all = list;
      _classOptions = classFromMeta.isNotEmpty
          ? classFromMeta.map((e) => e['name'] as String).toList()
          : _deriveClassifications(list);
      _tasteOptions =
          tasteFromMeta.isNotEmpty ? tasteFromMeta : _deriveTastes(list);
      _apply();
    });
  }

  List<String> _deriveClassifications(List<Map<String, dynamic>> list) {
    final set = <String>{};
    for (final i in list) {
      final types = (i['displayTypes'] as List?)?.cast<String>() ?? [];
      if (!types.contains('食材')) continue;
      final c = i['classification'] as String?;
      if (c != null && c.isNotEmpty) set.add(c);
    }
    return set.toList();
  }

  List<String> _deriveTastes(List<Map<String, dynamic>> list) {
    final set = <String>{};
    for (final i in list) {
      for (final t in (i['taste'] as Map?)?.keys ?? []) {
        set.add(t.toString());
      }
    }
    return set.toList();
  }

  bool _matchesTypeFilter(Map<String, dynamic> item, String filter) {
    final types = (item['displayTypes'] as List?)?.cast<String>() ?? [];
    if (filter == '调料') {
      return types.contains('调料') || types.contains('酱料');
    }
    return types.contains(filter);
  }

  void _apply() {
    final q = _query.trim().toLowerCase();
    _filtered = _all.where((i) {
      if (q.isNotEmpty) {
        final hit = (i['name'] as String).toLowerCase().contains(q) ||
            (i['desc'] as String? ?? '').toLowerCase().contains(q);
        if (!hit) return false;
      }
      if (widget.kind == 'food') {
        if (_classification != null) {
          final types = (i['displayTypes'] as List?)?.cast<String>() ?? [];
          if (!types.contains('食材')) return false;
          if (i['classification'] != _classification) return false;
        }
        if (_taste != null) {
          final tastes = i['taste'] as Map?;
          if (tastes == null || !tastes.containsKey(_taste)) return false;
        }
        if (_typeFilter != null && !_matchesTypeFilter(i, _typeFilter!)) {
          return false;
        }
      }
      return true;
    }).toList()
      ..sort(
        (a, b) => (a['name'] as String).compareTo(b['name'] as String),
      );
  }

  Future<void> _openDetail(Map<String, dynamic> item) async {
    _searchFocus.unfocus();
    clearScreenFocus();
    if (widget.kind == 'food') _filtersController.collapse();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => widget.kind == 'food'
            ? FoodIngredientDetailScreen(item: item)
            : AlchemyDetailScreen(item: item),
      ),
    );
    if (mounted) {
      _searchFocus.unfocus();
      clearScreenFocus();
      if (widget.kind == 'food') _filtersController.collapse();
    }
  }

  String _alchemySubtitle(Map<String, dynamic> item) {
    final boost = item['alchemyBoost'] as Map?;
    if (boost == null || boost.isEmpty) {
      return '炼金材料 · 无部位加成';
    }
    final parts = boost.entries.map((e) => '${e.key}+${e.value}').join(' · ');
    return '炼金材料 · $parts';
  }

  String _foodSubtitle(Map<String, dynamic> item) {
    final types = (item['displayTypes'] as List?)?.cast<String>() ?? [];
    final typeLabel = types.contains('酱料')
        ? '调料 · 酱料形态'
        : types.join(' · ');
    final cls = item['classification'] as String? ?? '';
    if (types.contains('食材') && cls.isNotEmpty) {
      return '$typeLabel · $cls';
    }
    return typeLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            decoration: const InputDecoration(
              hintText: '搜索材料名称…',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() {
              _query = v;
              _apply();
            }),
          ),
        ),
        FilterResetButton(
          visible: _hasActiveFilters,
          onReset: _resetFilters,
        ),
        if (widget.kind == 'food')
          CollapsibleFilters(
            controller: _filtersController,
            children: [
              FilterIconRow(
                label: '类型',
                chips: [
                  IconFilterChip(
                    selected: _typeFilter == null,
                    label: '全部',
                    onTap: () => setState(() {
                      _typeFilter = null;
                      _apply();
                    }),
                  ),
                  ..._foodTypeOptions.map(
                    (t) => IconFilterChip(
                      selected: _typeFilter == t,
                      label: t,
                      onTap: () => setState(() {
                        _typeFilter = _typeFilter == t ? null : t;
                        _apply();
                      }),
                    ),
                  ),
                ],
              ),
              FilterIconRow(
                label: '口味',
                chips: [
                  IconFilterChip(
                    selected: _taste == null,
                    label: '全部',
                    onTap: () => setState(() {
                      _taste = null;
                      _apply();
                    }),
                  ),
                  ..._tasteOptions.map(
                    (t) => IconFilterChip(
                      selected: _taste == t,
                      label: t,
                      onTap: () => setState(() {
                        _taste = _taste == t ? null : t;
                        _apply();
                      }),
                    ),
                  ),
                ],
              ),
              FilterPickerRow<String?>(
                label: '分类',
                value: _classification,
                hintWhenNull: '全部分类',
                sheetTitle: '选择分类',
                options: [
                  const WikiPickerOption(value: null, label: '全部分类'),
                  ..._classOptions.map(
                    (c) => WikiPickerOption(value: c, label: c),
                  ),
                ],
                onChanged: (v) => setState(() {
                  _classification = v;
                  _apply();
                }),
              ),
            ],
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final item = _filtered[i];
              return WikiListRow(
                leadingSize: AppLayout.listThumbnailSize,
                leading: TextBadge(
                  label: item['name'] as String? ?? '',
                  size: AppLayout.listThumbnailSize,
                  icon: widget.kind == 'food'
                      ? Icons.eco_outlined
                      : Icons.science_outlined,
                ),
                title: Text(
                  item['name'] as String,
                  style: AppTextStyles.listTitle(),
                ),
                subtitle: Text(
                  widget.kind == 'food'
                      ? _foodSubtitle(item)
                      : _alchemySubtitle(item),
                  style: AppTextStyles.listSubtitle(),
                ),
                onTap: () => _openDetail(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
