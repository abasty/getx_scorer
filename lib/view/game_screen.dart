import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = Get.find<Game>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Scorer'),
      ),
      body: Column(
        children: [
          const Expanded(child: ScoreTable()),
          Center(
            child: TextButton(
              onPressed: () {
                game.ctrlCancel();
                Get.snackbar(
                  'Annuler',
                  'Annule la dernière entrée.',
                );
              },
              child: const Text('Annuler'),
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreTable extends StatelessWidget {
  const ScoreTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Game>(
      builder: (game) {
        return Column(
          children: [
            Row(
              children: [
                for (int p = 0; p < game.columnCount; p++)
                  Container(
                    width: 96,
                    height: 48,
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        game.ctrlAddScore(p, 10);
                        game.scrollController.jumpTo(
                            game.scrollController.position.maxScrollExtent);
                      },
                      child: Text(
                        game.players[p],
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: game.scrollController,
                scrollDirection: Axis.vertical,
                itemCount: game.rowCount,
                itemBuilder: (context, row) {
                  return Row(
                    children: [
                      for (int p = 0; p < game.columnCount; p++)
                        Container(
                          width: 96,
                          height: 48,
                          alignment: Alignment.centerRight,
                          color: row.isEven ? Colors.green[50] : Colors.white,
                          child: Builder(
                            builder: (context) {
                              var score = game.getScore(p, row)[0];
                              return Text(
                                '${score < 0 ? "-" : score}',
                                style: const TextStyle(fontSize: 20.0),
                              );
                            },
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
