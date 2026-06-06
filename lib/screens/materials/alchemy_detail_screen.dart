import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/text_badge.dart';

class AlchemyDetailScreen extends StatelessWidget {
  const AlchemyDetailScreen({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final boost = item['alchemyBoost'] as Map<String, dynamic>? ?? {};
    final name = item['name'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: TextBadge(
              label: name,
              size: 100,
              icon: Icons.science_outlined,
            ),
          ),
          const SizedBox(height: 12),
          _info('稀有度', '${item['rarity']}'),
          _info('单件重量', '${item['weight']}'),
          if (item['classification'] != null &&
              '${item['classification']}'.isNotEmpty)
            _info('分类', '${item['classification']}'),
          const SizedBox(height: 8),
          Text(
            item['desc'] as String? ?? '',
            style: const TextStyle(height: 1.4),
          ),
          const SizedBox(height: 16),
          const Text('炼金加成', style: TextStyle(fontWeight: FontWeight.bold)),
          if (boost.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '无部位加成',
                style: TextStyle(color: AppColors.textHint),
              ),
            )
          else
            ...boost.entries.map(
              (e) => ListTile(
                dense: true,
                title: Text(e.key.toString()),
                trailing: Text('+${e.value}'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _info(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              k,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
