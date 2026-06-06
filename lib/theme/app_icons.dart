import 'package:flutter/material.dart';

/// 无游戏素材时用 Material 图标代替元素/烹饪方式等。
class AppIcons {
  AppIcons._();

  static IconData? element(String? elementKey) {
    switch (elementKey) {
      case 'water':
        return Icons.water_drop_outlined;
      case 'fire':
        return Icons.local_fire_department_outlined;
      case 'wind':
        return Icons.air_outlined;
      case 'soil':
        return Icons.landscape_outlined;
      default:
        return Icons.hub_outlined;
    }
  }

  static IconData? elementByLabel(String label) {
    switch (label) {
      case '水':
        return element('water');
      case '火':
        return element('fire');
      case '风':
        return element('wind');
      case '土':
        return element('soil');
      case '全部':
        return Icons.apps;
      default:
        return null;
    }
  }

  static IconData? cookType(String? iconKey) {
    switch (iconKey) {
      case 'hongkao':
        return Icons.bakery_dining_outlined;
      case 'dunzhu':
        return Icons.soup_kitchen_outlined;
      case 'jianzha':
        return Icons.outdoor_grill_outlined;
      case 'yinping':
        return Icons.ac_unit_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }

  static IconData? cookTypeById(int? id) {
    switch (id) {
      case 1:
        return cookType('hongkao');
      case 2:
        return cookType('dunzhu');
      case 3:
        return cookType('jianzha');
      case 4:
        return cookType('yinping');
      default:
        return cookType(null);
    }
  }

  /// 种族筛选/详情用单字（人马为「马」，其余为种族名首字）。
  static String raceGlyph(String? name) {
    if (name == null || name.isEmpty) return '?';
    if (name == '人马') return '马';
    return name.characters.first;
  }
}
