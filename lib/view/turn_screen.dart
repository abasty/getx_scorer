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
                GetX<GameController>(
                  builder: (game) => SizedBox(
                    width: 176,
                    child: DropdownButton<String>(
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
              ],
            ),
            GetX<GameController>(builder: (game) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetX<GameController>(builder: (game) {
                    return GestureDetector(
                      child: Container(
                        width: 64,
                        color: game.malus.value ? Colors.red : Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Text(
                            game.malus.value ? '-' : '+',
                            style: const TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () => game.malus.value = !game.malus.value,
                    );
                  }),
                  SizedBox(
                    width: 96,
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Text(
                        game.pointsTurn.value != ''
                            ? game.pointsTurn.value
                            : '0',
                        style: const TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  GetX<GameController>(builder: (game) {
                    return GestureDetector(
                      child: Container(
                        width: 64,
                        color: game.bonus.value ? Colors.green : Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
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
                ],
              );
            }),
            const DigitKeyboard(),
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
