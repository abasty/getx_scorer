import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/game.dart';
import 'game_view.dart';

class TurnDialog extends GameView {
  const TurnDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        GetX<GameController>(
          builder: (game) => DropdownButton<String>(
            isExpanded: true,
            icon: const Icon(Icons.person),
            value: game.players[game.playerTurn.value],
            onChanged: (String? newValue) =>
                game.playerTurn.value = game.players.indexOf(newValue!),
            items: game.players
                .map<DropdownMenuItem<String>>(
                  (value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
          ),
        ),
        GetX<GameController>(builder: (game) {
          return SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: _pointText(game),
            ),
          );
        }),
        GetX<GameController>(builder: (game) {
          return GestureDetector(
            child: Container(
              width: 64,
              color: game.bonus.value ? Colors.green : Colors.white,
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Text(
                  game.bonus.value ? '+50' : '+0',
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () => game.bonus.value = !game.bonus.value,
          );
        }),
        const DigitKeyboard(),
      ]),
    );
  }

  Text _pointText(GameController game) {
    var str = game.pointsTurn.value != '' ? game.pointsTurn.value : '0';
    if (str != '0' && game.malus.isTrue) str = '- $str';
    return Text(
      str,
      style: const TextStyle(fontSize: 20.0),
      textAlign: TextAlign.end,
    );
  }
}

class DigitKeyboard extends GameView {
  const DigitKeyboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 4; i <= 6; i++)
              OutlinedButton(
                onPressed: () => digit(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 7; i <= 9; i++)
              OutlinedButton(
                onPressed: () => digit(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 1; i <= 3; i++)
              OutlinedButton(
                onPressed: () => digit(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () => game.malus.value = !game.malus.value,
              child: const Text('+/-'),
            ),
            OutlinedButton(
              onPressed: () => digit(0),
              child: const Text('0'),
            ),
            OutlinedButton(
              onPressed: () => game.pointsTurn.value = '',
              child: const Text('C'),
            ),
          ],
        ),
      ],
    );
  }

  void digit(int n) {
    game.pointsTurn.value = game.pointsTurn.value + n.toString();
  }
}
