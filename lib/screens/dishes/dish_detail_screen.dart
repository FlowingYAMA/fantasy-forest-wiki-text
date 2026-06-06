import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_layout.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_icons.dart';
import '../../widgets/item_icon_tile.dart';
import '../../widgets/text_badge.dart';

class DishDetailScreen extends StatelessWidget {
  const DishDetailScreen({super.key, required this.dish});

  final Map<String, dynamic> dish;

  List<Map<String, dynamic>> _items(String key) {
    return (dish[key] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final mains = _items('mainFoodItems');
    final others = _items('otherFoodItems');
    final name = dish['name'] as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: TextBadge(
              label: name,
              size: 120,
              icon: Icons.restaurant_menu_outlined,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              name,
              style: AppTextStyles.sectionTitle(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ItemIconTile(
                label: dish['raceName'] as String? ?? '',
                glyph: AppIcons.raceGlyph(dish['raceName'] as String?),
                size: AppLayout.dishMetaIconSize,
                labelFontSize: AppLayout.dishMetaLabelSize,
                framed: false,
              ),
              ItemIconTile(
                label: dish['cookTypeName'] as String? ?? '',
                icon: AppIcons.cookTypeById(dish['cookType'] as int?),
                size: AppLayout.dishMetaIconSize,
                labelFontSize: AppLayout.dishMetaLabelSize,
                framed: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _sectionHeader('主料'),
          const SizedBox(height: 8),
          _ingredientGrid(mains, columns: 3),
          const SizedBox(height: 16),
          _sectionHeader('辅料'),
          const SizedBox(height: 8),
          others.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '无',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                  ),
                )
              : _ingredientGrid(others, columns: 2),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Center(
      child: Text(title, style: AppTextStyles.sectionTitle()),
    );
  }

  Widget _ingredientGrid(List<Map<String, dynamic>> items, {required int columns}) {
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final cellW = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final iconSize = (cellW - 10).clamp(50.0, 88.0);

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: gap,
          runSpacing: gap,
          children: items
              .map(
                (e) => SizedBox(
                  width: cellW,
                  child: ItemIconTile(
                    label: e['name'] as String? ?? '',
                    icon: Icons.eco_outlined,
                    size: iconSize,
                    cellWidth: cellW,
                    labelFontSize: AppLayout.ingredientLabelSize,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
