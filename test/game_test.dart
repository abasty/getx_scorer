import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_scorer/view_model/game.dart';

void main() async {
  var game = Game('ID1', ['toto', 'tata', 'titi']);
  test('Game()', () {
    assert(listEquals(game.getScore(0, 0), [-1, 0]));
  });
  test('Game.ctrlAddScore,', () async {
    await game.ctrlAddScore(0, 100);
    await game.ctrlAddScore(1, 25);
    await game.ctrlAddScore(2, 75);
    var sum = 0;
    for (int i = 0; i < game.players.length; i++) {
      sum += game.getScore(i, 0)[1];
    }
    assert(sum == 200);
  });
}
