import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/game.dart';

abstract class GameView extends StatelessWidget {
  final String? tag = null;

  const GameView({Key? key}) : super(key: key);

  GameController get game => GetInstance().find<GameController>(tag: tag);

  @override
  Widget build(BuildContext context);
}
