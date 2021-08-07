import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view/turn_screen.dart';

import '../view_model/game.dart';
import 'game_view.dart';

class GameScreen extends GameView {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compteur de points'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              var words = value.split(' ');
              switch (words[0]) {
                case 'Annuler':
                  game.doCancel();
                  break;
                case 'Créer':
                  game.doInitNewGameState();
                  Get.toNamed('/new');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Annuler derniere saisie', 'Créer nouvelle partie'}
                  .map((String choice) =>
                      PopupMenuItem<String>(value: choice, child: Text(choice)))
                  .toList();
            },
          ),
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
        var names = Row(
          children: [
            for (int p = 0; p < game.columnCount; p++)
              SizedBox(
                width: (Get.width - 16.0) / game.columnCount,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    game.playerTurn.value = p;
                    game.pointsTurn.value = '';
                    game.bonus.value = false;
                    game.malus.value = false;
                    Get.defaultDialog(
                      title: 'Tour de jeu',
                      content: const TurnDialog(),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        game.players[p],
                        style: const TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
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
                        var delta = game.getScore(p, row)[1];
                        Widget text;
                        if (delta != 0) {
                          text = Text(
                            '${score < 0 ? "-" : score}',
                            style: const TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.end,
                          );
                        } else {
                          text = Text(
                            score == -1 ? '...' : 'passe',
                            style: const TextStyle(
                                fontSize: 12.0, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.end,
                          );
                        }
                        return SizedBox(
                          width: (Get.width - 16.0) / game.columnCount,
                          height: 32,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8.0,
                              ),
                              if (delta != 0)
                                Text(
                                  delta >= 0 ? '+$delta' : '-$delta',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic),
                                ),
                              const Spacer(),
                              text,
                            ],
                          ),
                        );
                      },
                    )
                ],
              ),
            );
          },
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
