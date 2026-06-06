import 'package:flutter/material.dart';
import 'dishes/dish_list_screen.dart';
import 'magic/magic_list_screen.dart';
import 'materials/material_tabs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DishListScreen(),
      const MagicListScreen(),
      const MaterialTabsScreen(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('空想森林攻略Demo')),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant), label: '食谱'),
          NavigationDestination(icon: Icon(Icons.auto_fix_high), label: '法阵'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: '材料'),
        ],
      ),
    );
  }
}
