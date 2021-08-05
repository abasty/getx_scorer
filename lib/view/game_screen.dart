import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compteur de points'),
        actions: [
          IconButton(
              onPressed: () {
                var game = Get.find<GameController>();
                game.doCancel();
              },
              icon: const Icon(Icons.cancel)),
          IconButton(
              onPressed: () {
                var game = Get.find<GameController>();
                game.doInitNewGameState();
                Get.toNamed('/new');
              },
              icon: const Icon(Icons.create)),
        ],
      ),
      body: const ScoreTable(),
    );
  }
}

class ScoreTable extends StatelessWidget {
  const ScoreTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (game) {
        var scores = ListView.builder(
          controller: game.scrollController,
          scrollDirection: Axis.vertical,
          itemCount: game.rowCount,
          itemBuilder: (context, row) {
            return Container(
              color: row.isEven ? Colors.green[50] : Colors.white,
              child: Row(
                children: [
                  for (int p = 0; p < game.columnCount; p++)
                    Builder(
                      builder: (context) {
                        var score = game.getScore(p, row)[0];
                        return SizedBox(
                          width: (Get.width - 16.0) / game.columnCount,
                          child: Text(
                            '${score < 0 ? "-" : score}',
                            style: const TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.end,
                          ),
                        );
                      },
                    )
                ],
              ),
            );
          },
        );
        var names = Row(
          children: [
            for (int p = 0; p < game.columnCount; p++)
              SizedBox(
                width: (Get.width - 16.0) / game.columnCount,
                height: 48,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/turn', arguments: p.toString());
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      game.players[p],
                      style: const TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              )
          ],
        );
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              names,
              Expanded(
                child: scores,
              ),
            ],
          ),
        );
      },
    );
  }
}
