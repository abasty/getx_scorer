import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(ScorerApp());
}

class ScorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Game Scorer'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              Get.snackbar(
                'Classement',
                'Le leader est actuellement : Zardoz',
              );
            },
            child: Text('Classement'),
          ),
        ),
      ),
    );
  }
}
