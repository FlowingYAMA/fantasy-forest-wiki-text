import 'package:flutter_test/flutter_test.dart';
import 'package:fantasy_forest_wiki_text/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FantasyForestWikiTextApp());
    expect(find.text('空想森林攻略Demo'), findsOneWidget);
  });
}
