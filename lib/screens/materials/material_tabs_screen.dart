import 'package:flutter/material.dart';
import 'ingredient_list_screen.dart';

class MaterialTabsScreen extends StatelessWidget {
  const MaterialTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '食材'),
              Tab(text: '炼金'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                IngredientListScreen(kind: 'food'),
                IngredientListScreen(kind: 'alchemy'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
