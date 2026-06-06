import 'dart:convert';
import 'package:flutter/services.dart';

class WikiRepository {
  WikiRepository._();
  static final WikiRepository instance = WikiRepository._();

  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/game/wiki_data.json');
    _cache = jsonDecode(raw) as Map<String, dynamic>;
    return _cache!;
  }

  Future<Map<String, dynamic>> meta() async {
    final data = await load();
    return (data['meta'] as Map<String, dynamic>?) ?? {};
  }

  Future<List<Map<String, dynamic>>> dishes() async {
    final data = await load();
    return (data['dishes'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> magicCircles() async {
    final data = await load();
    return (data['magicCircles'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> foodIngredients() async {
    final data = await load();
    return (data['ingredientsFood'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> alchemyIngredients() async {
    final data = await load();
    return (data['ingredientsAlchemy'] as List).cast<Map<String, dynamic>>();
  }

  /// Unique ingredient names used in official dishes (for recipe filter).
  Future<List<String>> dishIngredientFilterOptions() async {
    final list = await dishes();
    final names = <String>{};
    for (final d in list) {
      for (final key in ['mainFoodItems', 'otherFoodItems']) {
        for (final item in (d[key] as List?) ?? []) {
          final name = (item as Map)['name'] as String?;
          if (name != null && name.isNotEmpty) names.add(name);
        }
      }
    }
    final sorted = names.toList()..sort();
    return sorted;
  }
}
