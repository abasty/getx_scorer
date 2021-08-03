import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';
// import 'package:get/get.dart';
// import '../view_model/game.dart';

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
              child: GetBuilder<GameControler>(builder: (game) {
                return ListView(
                  children: game.players
                      .map(
                        (e) => ListTile(
                          title: Text(e),
                        ),
                      )
                      .toList(),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
