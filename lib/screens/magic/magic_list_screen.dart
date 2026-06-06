import 'package:flutter/material.dart';
import '../../data/wiki_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_layout.dart';
import '../../widgets/framed_thumbnail.dart';
import '../../widgets/icon_filter_chip.dart';
import '../../widgets/magic_circle_diagram.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/wiki_list_row.dart';
import 'magic_detail_screen.dart';

class MagicListScreen extends StatefulWidget {
  const MagicListScreen({super.key});

  @override
  State<MagicListScreen> createState() => _MagicListScreenState();
}

class _MagicListScreenState extends State<MagicListScreen> {
  List<Map<String, dynamic>> _items = [];
  String _element = '全部';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await WikiRepository.instance.magicCircles();
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filtered {
    if (_element == '全部') return _items;
    return _items.where((m) => m['element'] == _element).toList();
  }

  String _statLine(Map<String, dynamic> stats, List<String> keys) {
    final parts = <String>[];
    for (final k in keys) {
      final v = stats[k];
      if (v == null) continue;
      if (k == '暴击率' || k == '暴击伤害') {
        parts.add('$k $v%');
      } else {
        parts.add('$k $v');
      }
    }
    return parts.join('  ');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    const elements = ['全部', '土', '水', '火', '风'];
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(
            children: elements.map((e) {
              final sel = e == _element;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconFilterChip(
                  selected: sel,
                  label: e,
                  icon: AppIcons.elementByLabel(e),
                  backgroundColor: AppColors.filterChipTintForLabel(e),
                  onTap: () => setState(() => _element = e),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final m = _filtered[i];
              final stats = m['stats'] as Map<String, dynamic>? ?? {};
              final diagram = m['diagram'] as Map<String, dynamic>?;
              final elementKey = m['elementKey'] as String?;
              final leadingSize = AppLayout.listThumbnailSize;
              final diagramInset = AppLayout.magicListDiagramInset;
              final inner = leadingSize - diagramInset * 2;
              return WikiListRow(
                leadingSize: leadingSize,
                leading: FramedThumbnail(
                  size: leadingSize,
                  backgroundColor: AppColors.elementTint(elementKey),
                  inset: diagramInset,
                  child: MagicCircleDiagram(
                    diagram: diagram,
                    elementKey: elementKey,
                    compact: true,
                    height: inner,
                    radiusScale: 0.36,
                  ),
                ),
                title: Text(
                  '${m['element']} · ${m['level']}阶 · ${m['name']}',
                  maxLines: 2,
                  style: AppTextStyles.listTitle(),
                ),
                extraLines: [
                  Text(
                    _statLine(stats, ['攻击力', '消耗魔力']),
                    maxLines: 2,
                    style: AppTextStyles.listSubtitle(),
                  ),
                  Text(
                    _statLine(stats, ['暴击率', '暴击伤害']),
                    maxLines: 2,
                    style: AppTextStyles.listCaption(),
                  ),
                ],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MagicDetailScreen(circle: m),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
