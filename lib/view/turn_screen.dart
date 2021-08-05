import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

class TurnScreen extends GetView<GameController> {
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
              controller.doAddScore(0, Random().nextInt(33) + 1);
              controller.scrollController
                  .jumpTo(controller.scrollController.position.maxScrollExtent);
              Get.back();
            },
          )
        ],
      ),
      body: GetBuilder<GameController>(builder: (game) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropdownButton<String>(
                icon: const Icon(Icons.person),
                value: game.players[int.parse(Get.arguments.toString())],
                onChanged: (String? newValue) {
                  game.playerTurn.value = newValue!;
                },
                items:
                    game.players.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
        );
      }),
    );
  }
}
