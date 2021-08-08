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
          return _pointText(game);
        }),
        const SizedBox(height: 8.0),
        const DigitKeyboard(),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                game.doAddScore(game.playerTurn.value, 0);
                Get.back();
              },
              child: const Text('PASSER'),
            ),
            TextButton(
              onPressed: () {
                var points = int.tryParse(game.pointsTurn.value);
                if (points != null) {
                  if (game.malus.value) points = -points;
                  if (game.bonus.value) points += 50;
                  game.doAddScore(game.playerTurn.value, points);
                }
                Get.back();
              },
              child: const Text('VALIDER'),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _pointText(GameController game) {
    var str = game.pointsTurn.value != '' ? game.pointsTurn.value : '0';
    if (str != '0' && game.malus.isTrue) str = '-$str';
    if (game.bonus.isTrue && game.pointsTurn.value != '') {
      var total = int.parse(game.pointsTurn.value) + 50;
      str = '$str+50=$total';
    }
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: Colors.black12,
        child: Text(
          str,
          style: const TextStyle(
            fontSize: 20.0,
            //fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Segment14',
          ),
          textAlign: TextAlign.end,
        ),
      ),
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
          children: <Widget>[
            for (int i = 7; i <= 9; i++) _digitButton(i),
            const Spacer(),
            _rectButton(
              text: 'AC',
              onPressed: () {
                game.pointsTurn.value = '';
                game.bonus.value = false;
                game.malus.value = false;
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            for (int i = 4; i <= 6; i++) _digitButton(i),
            const Spacer(),
            _rectButton(
              text: '+50',
              onPressed: () {
                game.bonus.value = !game.bonus.value;
                if (game.bonus.isTrue) game.malus.value = false;
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            for (int i = 1; i <= 3; i++) _digitButton(i),
            const Spacer(),
            _rectButton(
              text: '+/-',
              onPressed: () {
                game.malus.value = !game.malus.value;
                if (game.malus.isTrue) game.bonus.value = false;
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(
              width: 48.0,
              height: 48.0,
            ),
            _digitButton(0),
          ],
        ),
      ],
    );
  }

  Widget _squareButton(
      {required String text, required void Function() onPressed}) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  Widget _rectButton(
      {required String text, required void Function() onPressed}) {
    return SizedBox(
      width: 64.0,
      height: 48.0,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  Widget _digitButton(int n) {
    return _squareButton(
      text: n.toString(),
      onPressed: () =>
          game.pointsTurn.value = game.pointsTurn.value + n.toString(),
    );
  }
}
