import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/magic_circle_diagram.dart';
import '../../widgets/text_badge.dart';

class MagicDetailScreen extends StatelessWidget {
  const MagicDetailScreen({super.key, required this.circle});

  final Map<String, dynamic> circle;

  @override
  Widget build(BuildContext context) {
    final stats = circle['stats'] as Map<String, dynamic>? ?? {};
    final elementKey = circle['elementKey'] as String? ?? '';
    final diagram = circle['diagram'] as Map<String, dynamic>?;
    final graphs = diagram?['graphs'] as List? ?? [];
    final graphOrder = _graphIndicesByLineCount(graphs);
    final graphStones =
        (circle['graphMagicStones'] as List?)?.cast<num>() ?? <num>[];
    final width = MediaQuery.sizeOf(context).width - 32;
    final elementLabel = circle['element'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${circle['element']} ${circle['level']}阶'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Text(
            circle['name'] as String? ?? '',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextBadge(
                label: elementLabel,
                size: 40,
                icon: AppIcons.element(elementKey),
                framed: true,
                backgroundColor: AppColors.elementTint(elementKey),
              ),
              const SizedBox(width: 12),
              Text(
                '$elementLabel 元素',
                style: AppTextStyles.listSubtitle(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('结构图', style: AppTextStyles.sectionTitle()),
          const SizedBox(height: 8),
          _diagramBox(
            width: width,
            elementKey: elementKey,
            child: MagicCircleDiagram(
              diagram: diagram,
              elementKey: elementKey,
              height: width - 32,
              radiusScale: 0.38,
            ),
          ),
          const SizedBox(height: 20),
          Text('属性', style: AppTextStyles.sectionTitle()),
          _stat('攻击力', stats['攻击力']),
          _stat('暴击率', stats['暴击率'], suffix: '%'),
          _stat('暴击伤害', stats['暴击伤害'], suffix: '%'),
          _stat('消耗魔力', stats['消耗魔力']),
          _stat('消耗魔法石', stats['消耗魔法石']),
          const SizedBox(height: 20),
          Text('图案详解', style: AppTextStyles.sectionTitle()),
          if (graphs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('暂无图案数据'),
            )
          else
            ...List.generate(graphOrder.length, (displayIndex) {
              final graphIndex = graphOrder[displayIndex];
              final stones = graphIndex < graphStones.length
                  ? graphStones[graphIndex]
                  : null;
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '图案 ${displayIndex + 1}'
                      '${stones != null ? ' · 消耗魔法石 $stones' : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _diagramBox(
                      width: width,
                      elementKey: elementKey,
                      child: MagicCircleDiagram(
                        diagram: diagram,
                        graphIndex: graphIndex,
                        elementKey: elementKey,
                        height: width - 32,
                        radiusScale: 0.38,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _diagramBox({
    required double width,
    required Widget child,
    String? elementKey,
  }) {
    return Center(
      child: SizedBox(
        width: width,
        height: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.elementTint(elementKey),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.9),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, dynamic value, {String suffix = ''}) {
    if (value == null) return const SizedBox.shrink();
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      trailing: Text(
        '$value$suffix',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

int _graphLineCount(dynamic graph) {
  return ((graph as Map)['lines'] as List?)?.length ?? 0;
}

List<int> _graphIndicesByLineCount(List graphs) {
  final indices = List.generate(graphs.length, (i) => i);
  // 过滤掉lines为空的graph
  indices.removeWhere((i) => _graphLineCount(graphs[i]) == 0);
  indices.sort((a, b) {
    final diff = _graphLineCount(graphs[a]) - _graphLineCount(graphs[b]);
    if (diff != 0) return diff;
    return a.compareTo(b);
  });
  return indices;
}
