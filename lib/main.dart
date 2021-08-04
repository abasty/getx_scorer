import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_scorer/view/game_screen.dart';
import 'package:getx_scorer/view/new_screen.dart';
import 'package:getx_scorer/view_model/game.dart';

Future<void> main() async {
  await GetStorage.init('game_app');
  Get.put(GameControler(['Véro', 'Alain', 'Martine'], id: 'game_app'));
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const GameScreen(),
        ),
        GetPage(
          name: '/new',
          page: () => const NewScreen(),
          transition: Transition.zoom,
        ),
      ],
    ),
  );
}
