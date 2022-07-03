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
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final game = Get.find<GameController>();
              game.doNewGame();
              Get.back();
            },
          ),
        ],
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
              child: GetBuilder<GameController>(
                builder: (game) {
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      game.doReorderPlayers(oldIndex, newIndex);
                    },
                    children: <Widget>[
                      for (int index = 0;
                          index < game.playersNew.length;
                          index++)
                        Dismissible(
                          key: Key(game.playersNew[index]),
                          background: Container(
                            color: Colors.red,
                            child: const Center(child: Text('Supprimer')),
                          ),
                          onDismissed: (dir) {
                            game.doRemovePlayer(index);
                          },
                          child: ListTile(
                            title: Text(game.playersNew[index]),
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                color: Colors.red,
                                onPressed: () {
                                  game.doRemovePlayer(index);
                                },
                              ),
                            ),
                          ),
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
        backgroundColor: Colors.red,
        onPressed: () {
          final game = Get.find<GameController>();
          Get.defaultDialog(
            title: 'Ajouter un joueur',
            textCancel: 'Non',
            textConfirm: 'Oui',
            onConfirm: () {
              game.doAddNew();
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
