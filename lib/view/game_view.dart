import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_scorer/view_model/game.dart';

abstract class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  final String? tag = null;

  get game => GetInstance().find<GameController>(tag: tag);

  @override
  Widget build(BuildContext context);
}
