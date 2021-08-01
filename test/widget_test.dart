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

void main() {
  // ignore: unused_local_variable
  var game = Get.put(Game('ID', ['Véro', 'Alain', 'Martine']));

  testWidgets('Snackbar test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const GetMaterialApp(home: GameScreen()),
    );

    // Verify that just one 'Classement' widget is on the screen
    expect(find.text('Annuler'), findsOneWidget);
    // Tap the 'Annuler' button.
    await tester.tap(find.text('Annuler'));
    // Schedule animation
    await tester.pump();
    // Start animation
    await tester.pump();
    // Verify that our snackbar is displayed.
    expect(find.text('Annuler'), findsNWidgets(2));
    // Wait default animation time
    await tester.pump(const Duration(seconds: 4));
    // Verify that just one 'Annuler' widget is on the screen
    expect(find.text('Annuler'), findsOneWidget);
  });
}
