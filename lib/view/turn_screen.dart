import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

class TurnScreen extends StatelessWidget {
  const TurnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour de jeu'),
      ),
      body: GetBuilder<GameControler>(builder: (game) {
        return Column(
          children: [
            DropdownButton<String>(
              value: game.players[0],
              onChanged: (String? newValue) {
                game.playerTurn = newValue!;
              },
              items: game.players.map<DropdownMenuItem<String>>((String value) {
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
        );
      }),
    );
  }
}
