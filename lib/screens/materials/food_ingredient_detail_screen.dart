import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/text_badge.dart';

/// 食材详情（无摆盘模块）。
class FoodIngredientDetailScreen extends StatelessWidget {
  const FoodIngredientDetailScreen({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final item = this.item;
    final name = item['name'] as String? ?? '';
    final types = (item['displayTypes'] as List?)?.cast<String>() ?? [];
    final typeText = types
        .map((t) => t == '酱料' ? '酱料形态' : t)
        .join('、');
    final tastes =
        (item['taste'] as Map?)?.keys.cast<String>().toList() ?? <String>[];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: TextBadge(
              label: name,
              size: 100,
              icon: Icons.eco_outlined,
            ),
          ),
          const SizedBox(height: 16),
          _info('稀有度', '${item['rarity']}'),
          _info('单件重量', '${item['weight']}'),
          if (typeText.isNotEmpty) _info('类型', typeText),
          if (_showClassification(item))
            _info('分类', '${item['classification']}'),
          if (tastes.isNotEmpty) _info('口味', tastes.join('、')),
          const SizedBox(height: 8),
          Text(
            item['desc'] as String? ?? '',
            style: const TextStyle(
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  bool _showClassification(Map<String, dynamic> item) {
    final types = (item['displayTypes'] as List?)?.cast<String>() ?? [];
    if (!types.contains('食材')) return false;
    final cls = item['classification'] as String? ?? '';
    return cls.isNotEmpty;
  }

  Widget _info(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              k,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
