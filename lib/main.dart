import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        body: Center(
          child: TextButton(
            onPressed: () {
              Get.snackbar(
                'Classement',
                'Le leader est actuellement : Zardoz',
              );
            },
            child: const Text('Classement'),
          ),
        ),
      ),
    );
  }
}
