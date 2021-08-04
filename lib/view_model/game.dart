import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// A game defined by an [id] and a list of [players].
class GameControler extends GetxController {
  static const _tableKey = 'table';
  static const _playersKey = 'players';

  /// The [id] of the game.
  final String? id;

  /// List of players (names).
  final List<String> players;

  /// List of score columns. Each column is linked with a player in the
  /// [players] list.
  final RxList<List<int>> _table;

  /// The scroll controller
  final scrollController = ScrollController();

  final List<int> _cancelList = [];

  final GetStorage? _storage;

  /// [NewScreen] state: list of players beeing edited.
  final List<String> playersNew = [];

  /// [NewScreen] state : Name of new player
  String? playerNew;

  /// Create a new game given an ID and a list of players.
  GameControler(this.players, {this.id})
      : _table = players.map((e) => <int>[]).toList().obs,
        _storage = id != null ? GetStorage(id) : null;

  /// [cancelable] is true iff the cancel list is not empty.
  bool get cancelable => _cancelList.isNotEmpty;

  /// [columnCount] is the number of column (i.e. players) in the game
  int get columnCount => players.length;

  /// [rowCount] is the maximum number of elements in all columns.
  int get rowCount => _table.map((c) => c.length).reduce(max);

  /// [NewScreen] state : add a new player
  void addNew() {
    if (playerNew != null) playersNew.add(playerNew!);
    update();
  }

  /// Add a score to the player score column.
  void ctrlAddScore(int player, int score) {
    _cancelList.add(player);
    var list = _table[player];
    var length = list.length;
    list.add(length == 0 ? score : list[length - 1] + score);
    _writeAndUpdate();
  }

  /// Cancel the last [ctrlAddScore] method call.
  void ctrlCancel() {
    if (_cancelList.isEmpty) return;
    var player = _cancelList.removeLast();
    _table[player].removeLast();
    _writeAndUpdate();
  }

  /// Empty score table and cancel list.
  void ctrlRAZ() {
    _table.clear();
    _table.addAll(players.map((e) => <int>[]).toList().obs);
    _cancelList.clear();
    _writeAndUpdate();
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

  /// Init [NewScreen] state
  void initNew() {
    playersNew.clear();
    playersNew.addAll(players);
    playerNew = null;
  }

  /// Read players and score table from storage, if possible
  @override
  void onInit() async {
    super.onInit();

    if (_storage == null) return;

    /// Read players
    var playersRaw = _storage!.read(_playersKey);
    if (playersRaw is List) {
      List<String> playersString =
          playersRaw.map((name) => name as String).toList();
      players.clear();
      players.addAll(playersString);
    } else {
      _storage!.write(_playersKey, players);
    }

    /// Read scores table
    _table.clear();
    List<List<int>> tableInt;
    var tableRaw = _storage!.read(_tableKey);
    if (tableRaw is List) {
      tableInt = tableRaw.map((player) {
        var scores = (player as List).map((score) {
          return score as int;
        }).toList();
        return scores;
      }).toList();
    } else {
      tableInt = players.map((e) => <int>[]).toList();
    }
    _table.addAll(tableInt);
  }

  /// [NewScreen] state : remove a player
  void removeNew(int index) {
    playersNew.removeAt(index);
    update();
  }

  /// [NewScreen] state : reorder players
  void reorderNew(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = playersNew.removeAt(oldIndex);
    playersNew.insert(newIndex, item);
    update();
  }

  /// Write _table to persistent storage and update UI
  void _writeAndUpdate() {
    _storage?.write(_tableKey, _table);
    update();
  }
}
