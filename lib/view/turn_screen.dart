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
            icon: const Icon(Icons.check),
            onPressed: () {
              var points = int.tryParse(game.pointsTurn);
              if (points != null) {
                game.doAddScore(game.playerTurn.value, points);
              }
              Get.back();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GetX<GameController>(
              builder: (game) {
                return DropdownButton<String>(
                  icon: const Icon(Icons.person),
                  value: game.players[game.playerTurn.value],
                  onChanged: (String? newValue) =>
                      game.playerTurn.value = game.players.indexOf(newValue!),
                  items: game.players
                      .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                );
              },
            ),
            TextField(
              decoration: const InputDecoration(
                // icon: Icon(Icons.money),
                labelText: 'Points marqués pendant ce tour',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              autofocus: true,
              onChanged: (value) => game.pointsTurn = value,
            ),
            const Divider(
              color: Colors.white,
              height: 48,
            ),
            const DigitKeyboard(),
          ],
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
            for (int i = 7; i <= 9; i++)
              OutlinedButton(
                onPressed: () => digit(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          children: <Widget>[
            for (int i = 4; i <= 6; i++)
              OutlinedButton(
                onPressed: () => digit(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          children: <Widget>[
            for (int i = 1; i <= 3; i++)
              OutlinedButton(
                onPressed: () => digit(i),
                child: Text(i.toString()),
              )
          ],
        ),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: () {},
              child: const Text('+/-'),
            ),
            OutlinedButton(
              onPressed: () => digit(0),
              child: const Text('0'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('C'),
            ),
          ],
        ),
      ],
    );
  }

  void digit(int n) {
    print(n.toString());
  }
}
