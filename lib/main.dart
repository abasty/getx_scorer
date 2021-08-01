import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

void main() {
  runApp(const ScorerApp());
}

class ScorerApp extends StatelessWidget {
  const ScorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const ScoreTable(),
            const Divider(),
            Center(
              child: TextButton(
                onPressed: () {
                  game.ctrlAddScore(0, 10);
                  Get.snackbar(
                    'Classement',
                    'Le leader est actuellement : Zardoz',
                  );
                },
                child: const Text('Classement'),
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
    return DataTable(
      columns: [
        for (var name in game.players)
          DataColumn(
            label: Text(
              name,
              style: const TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
          ),
      ],
      rows: <DataRow>[
        for (var row = 0; row < game.rowCount; row++)
          DataRow(
            cells: [
              for (var column = 0; column < game.columnCount; column++)
                DataCell(
                  Text('${game.getScore(column, row)[0]}'),
                ),
            ],
          ),
      ],
    );
  }
}
