import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

void main() {
  Get.put(Game('ID', ['Véro', 'Alain', 'Martine']));
  runApp(const ScorerApp());
}

class ScorerApp extends StatelessWidget {
  const ScorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = Get.find<Game>();

    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
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
      builder: (game) => SingleChildScrollView(
        child: DataTable(
          columns: [
            for (int column = 0; column < game.columnCount; column++)
              DataColumn(
                numeric: true,
                label: TextButton(
                  onPressed: () {
                    game.ctrlAddScore(column, 10);
                  },
                  child: Text(
                    game.players[column],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
          rows: <DataRow>[
            for (int row = 0; row < game.rowCount; row++)
              DataRow(
                cells: [
                  for (int column = 0; column < game.columnCount; column++)
                    DataCell(
                      Builder(
                        builder: (context) {
                          var score = game.getScore(column, row)[0];
                          return Text('${score > -1 ? score : '-'}');
                        },
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
