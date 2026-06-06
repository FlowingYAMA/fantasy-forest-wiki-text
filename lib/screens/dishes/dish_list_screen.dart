import 'package:flutter/material.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_layout.dart';
import '../../data/wiki_repository.dart';
import '../../widgets/collapsible_filters.dart';
import '../../widgets/filter_icon_row.dart';
import '../../widgets/icon_filter_chip.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/wiki_list_row.dart';
import '../../utils/focus_util.dart';
import '../../widgets/filter_reset_button.dart';
import '../../widgets/wiki_picker_field.dart';
import '../../widgets/text_badge.dart';
import 'dish_detail_screen.dart';

class DishListScreen extends StatefulWidget {
  const DishListScreen({super.key});

  @override
  State<DishListScreen> createState() => _DishListScreenState();
}

class _DishListScreenState extends State<DishListScreen> {
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _filtered = [];
  List<Map<String, dynamic>> _races = [];
  Map<int, int> _raceOrderById = {};
  List<Map<String, dynamic>> _cookTypes = [];
  List<String> _ingredientOptions = [];

  int? _raceId;
  int? _cookTypeId;
  String? _ingredientName;
  String _nameQuery = '';
  bool _loading = true;
  final ExpansionTileController _filtersController = ExpansionTileController();
  late final TextEditingController _searchController;

  bool get _hasActiveFilters =>
      _nameQuery.trim().isNotEmpty ||
      _raceId != null ||
      _cookTypeId != null ||
      _ingredientName != null;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _nameQuery = '';
      _searchController.clear();
      _raceId = null;
      _cookTypeId = null;
      _ingredientName = null;
      _applyFilter();
    });
    clearScreenFocus();
  }

  Future<void> _load() async {
    final repo = WikiRepository.instance;
    final meta = await repo.meta();
    final list = await repo.dishes();
    final ingOpts = await repo.dishIngredientFilterOptions();
    setState(() {
      _all = list;
      _races = (meta['races'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      _raceOrderById = {
        for (var i = 0; i < _races.length; i++) _races[i]['id'] as int: i,
      };
      _cookTypes =
          (meta['cookTypes'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      _ingredientOptions = ingOpts;
      _applyFilter();
      _loading = false;
    });
  }

  void _applyFilter() {
    final q = _nameQuery.trim().toLowerCase();
    _filtered = _all.where((d) {
      if (_raceId != null && d['raceId'] != _raceId) return false;
      if (_cookTypeId != null && d['cookType'] != _cookTypeId) return false;
      if (_ingredientName != null) {
        final names = <String>[];
        for (final key in ['mainFoodItems', 'otherFoodItems']) {
          for (final item in (d[key] as List?) ?? []) {
            names.add((item as Map)['name'] as String? ?? '');
          }
        }
        if (!names.contains(_ingredientName)) return false;
      }
      if (q.isNotEmpty) {
        final name = (d['name'] as String).toLowerCase();
        if (!name.contains(q)) return false;
      }
      return true;
    }).toList();
    _filtered.sort((a, b) {
      final ra = _raceOrderById[a['raceId'] as int] ?? 9999;
      final rb = _raceOrderById[b['raceId'] as int] ?? 9999;
      if (ra != rb) return ra.compareTo(rb);
      return ((a['name'] as String?) ?? '')
          .compareTo((b['name'] as String?) ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: '按菜名搜索…',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() {
              _nameQuery = v;
              _applyFilter();
            }),
          ),
        ),
        FilterResetButton(
          visible: _hasActiveFilters,
          onReset: _resetFilters,
        ),
        CollapsibleFilters(
          controller: _filtersController,
          children: [
            FilterIconRow(
              label: '种族',
              rowHeight: AppLayout.dishFilterRowHeight,
              chips: [
                IconFilterChip(
                  selected: _raceId == null,
                  label: '全部',
                  padding: AppLayout.dishFilterChipPadding,
                  rowHeight: AppLayout.dishFilterRowHeight,
                  labelFontSize: 16,
                  onTap: () => setState(() {
                    _raceId = null;
                    _applyFilter();
                  }),
                ),
                ..._races.map((r) {
                  final id = r['id'] as int;
                  final name = r['name'] as String? ?? '';
                  return IconFilterChip(
                    selected: _raceId == id,
                    label: name,
                    glyph: AppIcons.raceGlyph(name),
                    padding: AppLayout.dishFilterChipPadding,
                    rowHeight: AppLayout.dishFilterRowHeight,
                    onTap: () => setState(() {
                      _raceId = _raceId == id ? null : id;
                      _applyFilter();
                    }),
                  );
                }),
              ],
            ),
            FilterIconRow(
              label: '烹饪方式',
              rowHeight: AppLayout.dishFilterRowHeight,
              chips: [
                IconFilterChip(
                  selected: _cookTypeId == null,
                  label: '全部',
                  padding: AppLayout.dishFilterChipPadding,
                  rowHeight: AppLayout.dishFilterRowHeight,
                  labelFontSize: 16,
                  onTap: () => setState(() {
                    _cookTypeId = null;
                    _applyFilter();
                  }),
                ),
                ..._cookTypes.map((c) {
                  final id = c['id'] as int;
                  return IconFilterChip(
                    selected: _cookTypeId == id,
                    label: c['name'] as String?,
                    icon: AppIcons.cookType(c['iconKey'] as String?),
                    padding: AppLayout.dishFilterChipPadding,
                    rowHeight: AppLayout.dishFilterRowHeight,
                    onTap: () => setState(() {
                      _cookTypeId = _cookTypeId == id ? null : id;
                      _applyFilter();
                    }),
                  );
                }),
              ],
            ),
            FilterPickerRow<String?>(
              label: '食材',
              value: _ingredientName,
              hintWhenNull: '全部食材',
              sheetTitle: '选择食材',
              searchable: true,
              options: [
                const WikiPickerOption(value: null, label: '全部食材'),
                ..._ingredientOptions.map(
                  (n) => WikiPickerOption(value: n, label: n),
                ),
              ],
              onChanged: (v) => setState(() {
                _ingredientName = v;
                _applyFilter();
              }),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final d = _filtered[i];
              final name = d['name'] as String? ?? '';
              return WikiListRow(
                leadingSize: AppLayout.listThumbnailSize,
                leading: TextBadge(
                  label: name,
                  size: AppLayout.listThumbnailSize,
                  icon: Icons.restaurant_menu_outlined,
                ),
                title: Text(name, style: AppTextStyles.listTitle()),
                subtitle: Text(
                  '${d['raceName']} · ${d['cookTypeName']}',
                  style: AppTextStyles.listSubtitle(),
                ),
                onTap: () async {
                  clearScreenFocus();
                  _filtersController.collapse();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DishDetailScreen(dish: d),
                    ),
                  );
                  if (!context.mounted) return;
                  clearScreenFocus();
                  _filtersController.collapse();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
