import 'dart:math';

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
              game.doAddScore(0, Random().nextInt(33) + 1);
              game.scrollController
                  .jumpTo(game.scrollController.position.maxScrollExtent);
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
                  onChanged: (String? newValue) {
                    game.playerTurn.value = game.players.indexOf(newValue!);
                  },
                  items: game.players
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.input),
                hintText: 'Points marqués pendant ce tour',
                labelText: 'Points',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
