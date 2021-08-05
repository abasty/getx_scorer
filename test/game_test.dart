import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

void main() async {
  var game = Get.put(GameController(['Véro', 'Alain', 'Martine']));
  test('Game()', () {
    assert(listEquals(game.getScore(0, 0), [-1, 0]));
  });
  test('Game.ctrlAddScore,', () async {
    game.doAddScore(0, 100);
    game.doAddScore(1, 25);
    game.doAddScore(2, 75);
    var sum = 0;
    for (int i = 0; i < game.players.length; i++) {
      sum += game.getScore(i, 0)[1];
    }
    assert(sum == 200);
    assert(game.rowCount == 1);
    game.doAddScore(1, 33);
    assert(game.rowCount == 2);
    game.doCancel();
    assert(game.rowCount == 1);
  });
}
