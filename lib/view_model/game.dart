import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// A game defined by an [id] and a list of [players].
class Game extends GetxController {
  static const storageName = 'getx_scorer';
  static const _tableKey = 'table';

  /// The [id] of the game.
  final String id;

  /// List of players (names).
  final List<String> players;

  /// List of score columns. Each column is linked with a player in the
  /// [players] list.
  final RxList<List<int>> _table;

  /// The scroll controller
  final scrollController = ScrollController();

  final List<int> _cancelList = [];

  final _storage = GetStorage(storageName);

  /// Create a new game given an ID and a list of players.
  Game(this.id, this.players)
      : _table = players.map((e) => <int>[]).toList().obs;

  @override
  void onInit() async {
    super.onInit();
    var tableDynamic = _storage.read(_tableKey) as List;
    var tableInt = tableDynamic.map((player) {
      var scores = (player as List).map((score) {
        return score as int;
      }).toList();
      return scores;
    }).toList();
    _table.clear();
    _table.addAll(tableInt);
  }

  /// [cancelable] is true iff the cancel list is not empty.
  bool get cancelable => _cancelList.isNotEmpty;

  /// [rowCount] is the maximum number of elements in all columns.
  int get rowCount => _table.map((c) => c.length).reduce(max);

  /// [columnCount] is the number of column (i.e. players) in the game
  int get columnCount => players.length;

  /// Add a score to the player score column.
  Future ctrlAddScore(int player, int score) async {
    _cancelList.add(player);
    var list = _table[player];
    var length = list.length;
    list.add(length == 0 ? score : list[length - 1] + score);
    _storage.write(_tableKey, _table); //jsonEncode(_table));
    update();
  }

  /// Cancel the last [ctrlAddScore] method call.
  Future ctrlCancel() async {
    if (_cancelList.isEmpty) return;
    var player = _cancelList.removeLast();
    _table[player].removeLast();
    _storage.write(_tableKey, _table);
    update();
  }

  /// Empty score table and cancel list.
  void ctrlRAZ() {
    _table.clear();
    _table.addAll(players.map((e) => <int>[]).toList().obs);
    _cancelList.clear();
    _storage.write(_tableKey, _table);
    update();
  }

  /// Gets a player line of score. Returns two values : the absolute score value
  /// for the line and the delta with the previous line.
  List<int> getScore(int player, int line) {
    var length = _table[player].length;
    if (line >= length) return [-1, 0];
    return [
      _table[player][line],
      line == 0
          ? _table[player][line]
          : _table[player][line] - _table[player][line - 1]
    ];
  }
}
