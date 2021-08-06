import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/game.dart';
import 'game_view.dart';

class TurnScreen extends GameView {
  const TurnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tour de jeu'),
          actions: [
            IconButton(
              icon: const Icon(Icons.ac_unit),
              onPressed: () {
                game.doAddScore(game.playerTurn.value, 0);
                Get.back();
              },
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                var points = int.tryParse(game.pointsTurn.value);
                if (points != null) {
                  if (game.malus.value) points = -points;
                  if (game.bonus.value) points += 50;
                  game.doAddScore(game.playerTurn.value, points);
                }
                Get.back();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: GetX<GameController>(
                    builder: (game) => DropdownButton<String>(
                      isExpanded: true,
                      value: game.players[game.playerTurn.value],
                      onChanged: (String? newValue) => game.playerTurn.value =
                          game.players.indexOf(newValue!),
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
                ),
                //const Spacer(),
                const SizedBox(width: 16),
                GetX<GameController>(builder: (game) {
                  return SizedBox(
                    width: 120,
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green)),
                      child: Text(
                        '${game.pointsTurn.value != "" ? game.pointsTurn.value : '0'} point(s).',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const DigitKeyboard(),
            GetX<GameController>(
                builder: (game) => ListTile(
                    title: const Text('Bonus (+50)'),
                    leading: Switch(
                      value: game.bonus.value,
                      onChanged: (value) => game.bonus.value = value,
                    ))),
            GetX<GameController>(
                builder: (game) => ListTile(
                    title: const Text('Malus fin de partie'),
                    leading: Switch(
                      value: game.malus.value,
                      onChanged: (value) => game.malus.value = value,
                    ))),
          ]),
        ));
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
