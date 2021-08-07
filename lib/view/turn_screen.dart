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
        const DigitKeyboard(),
      ]),
    );
  }

  Text _pointText(GameController game) {
    var str = game.pointsTurn.value != '' ? game.pointsTurn.value : '0';
    if (str != '0' && game.malus.isTrue) str = '- $str';
    if (game.bonus.isTrue && game.pointsTurn.value != '') {
      var total = int.parse(game.pointsTurn.value) + 50;
      str = '$str + 50 = $total';
    }
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 4; i <= 6; i++)
              OutlinedButton(
                onPressed: () => onDigitPressed(i),
                child: Text(i.toString()),
              ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                game.bonus.value = !game.bonus.value;
                if (game.bonus.isTrue) game.malus.value = false;
              },
              child: const Text('bonus'),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 7; i <= 9; i++)
              OutlinedButton(
                onPressed: () => onDigitPressed(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 1; i <= 3; i++)
              OutlinedButton(
                onPressed: () => onDigitPressed(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                game.malus.value = !game.malus.value;
                if (game.malus.isTrue) game.bonus.value = false;
              },
              child: const Text('+/-'),
            ),
            OutlinedButton(
              onPressed: () => onDigitPressed(0),
              child: const Text('0'),
            ),
            OutlinedButton(
              onPressed: () {
                game.pointsTurn.value = '';
                game.bonus.value = false;
                game.malus.value = false;
              },
              child: const Text('C'),
            ),
          ],
        ),
      ],
    );
  }

  void onDigitPressed(int n) {
    game.pointsTurn.value = game.pointsTurn.value + n.toString();
  }
}
