import 'dart:math';

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
      ),
      body: Column(
        children: [
          const Expanded(child: ScoreTable()),
          GetBuilder<GameControler>(
            builder: (game) {
              return Row(
                children: [
                  TextButton(
                    onPressed: game.cancelable ? () => game.doCancel() : null,
                    child: const IconText('ANNULER', Icons.cancel),
                  ),
                  TextButton(
                    // onPressed: game.rowCount > 0 ? () => game.ctrlRAZ() : null,
                    onPressed: () {
                      game.doInitNewGameState();
                      Get.toNamed('/new');
                    },
                    child: const IconText('RAZ', Icons.clear_all),
                  ),
                ],
              );
            },
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
    return GetBuilder<GameControler>(
      builder: (game) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  for (int p = 0; p < game.columnCount; p++)
                    Row(
                      children: [
                        SizedBox(
                          width: (Get.width - 16.0) / game.columnCount,
                          height: 48,
                          child: TextButton(
                            onPressed: () {
                              game.doAddScore(p, Random().nextInt(33) + 1);
                              game.scrollController.jumpTo(game
                                  .scrollController.position.maxScrollExtent);
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
                        ),
                      ],
                    )
                ],
              ),
              Expanded(
                child: ListView.builder(
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class IconText extends StatelessWidget {
  final String _title;
  final IconData _iconData;

  const IconText(this._title, this._iconData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconData),
          Text(_title),
        ],
      ),
    );
  }
}
