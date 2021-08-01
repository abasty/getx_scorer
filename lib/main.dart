import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view/game_screen.dart';
import 'package:getx_scorer/view_model/game.dart';

void main() {
  Get.put(Game('ID', ['Véro', 'Alain', 'Martine']));
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GameScreen(),
    ),
  );
}
