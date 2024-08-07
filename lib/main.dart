import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'view/game_screen.dart';
import 'view/new_screen.dart';
import 'view_model/game.dart';

Future<void> main() async {
  await GetStorage.init('game_app');
  Get.put(GameController(['Véro', 'Alain'], id: 'game_app'));
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        useMaterial3: false,
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
          transition: Transition.rightToLeft,
        ),
      ],
    ),
  );
}
