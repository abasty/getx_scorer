import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle partie'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Joueurs',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: GetBuilder<GameControler>(
                builder: (game) {
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      game.reorderNew(oldIndex, newIndex);
                    },
                    children: <Widget>[
                      for (int index = 0;
                          index < game.playersNew.length;
                          index++)
                        Dismissible(
                          key: Key(game.playersNew[index]),
                          child: ListTile(title: Text(game.playersNew[index])),
                          onDismissed: (dir) {
                            game.removeNew(index);
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final game = Get.find<GameControler>();
          Get.defaultDialog(
            title: 'Ajouter un joueur',
            textCancel: 'Non',
            textConfirm: 'Oui',
            onConfirm: () {
              game.addNew();
              Get.back();
            },
            content: TextField(
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              onChanged: (value) {
                game.playerNew = value;
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
