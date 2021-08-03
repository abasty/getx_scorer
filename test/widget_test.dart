// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view/game_screen.dart';
import 'package:getx_scorer/view_model/game.dart';

Future<void> main() async {
  var game = Get.put(GameControler(['Véro', 'Alain', 'Martine']));

  testWidgets('Players', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const GetMaterialApp(home: GameScreen()),
    );
    expect(find.text('Véro'), findsOneWidget);
    expect(find.text('Alain'), findsOneWidget);
    expect(find.text('Martine'), findsOneWidget);
    await tester.tap(find.text('Véro'));
    expect(find.text(game.getScore(0, 0)[0].toString()), findsNothing);
    await tester.pump();
    expect(find.text(game.getScore(0, 0)[0].toString()), findsOneWidget);
  });
}
