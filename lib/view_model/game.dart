import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// A game defined by an [id] and a list of [players].
class GameController extends GetxController {
  static const _tableKey = 'table';
  static const _playersKey = 'players';
  static const _cancelKey = 'cancel';

  /// The [id] of the game.
  final String? id;

  /// List of players (names).
  final List<String> players;

  /// List of score columns. Each column is linked with a player in the
  /// [players] list.
  final List<List<int>> _table;

  /// The scroll controller
  final scrollController = ScrollController();

  final List<int> _cancelList = [];

  final GetStorage? _storage;

  /// [NewScreen] state: list of players beeing edited.
  final List<String> playersNew = [];

  /// [NewScreen] state: Name of new player.
  String? playerNew;

  /// [TurnScreen] state: Selected player.
  var playerTurn = 0.obs;

  /// [TurnScreen] state: Points.obs
  var pointsTurn = ''.obs;

  /// [TurnScreen] state: Bonus.
  var bonus = false.obs;

  /// [TurnScreen] state: Malus.
  var malus = false.obs;

  /// Create a new game given an ID and a list of players.
  GameController(this.players, {this.id})
      : _table = players.map((e) => <int>[]).toList().obs,
        _storage = id != null ? GetStorage(id) : null;

  /// [cancelable] is true iff the cancel list is not empty.
  bool get cancelable => _cancelList.isNotEmpty;

  /// [columnCount] is the number of column (i.e. players) in the game
  int get columnCount => players.length;

  /// [rowCount] is the maximum number of elements in all columns.
  int get rowCount => _table.map((c) => c.length).reduce(max);

  /// [NewScreen] state : add a new player
  void doAddNew() {
    playersNew.addIf(playerNew != null, playerNew!);
    update();
  }

  /// Add a score to the player score column.
  void doAddScore(int player, int score) {
    _cancelList.add(player);
    var list = _table[player];
    var length = list.length;
    list.add(length == 0 ? score : list[length - 1] + score);
    _writeAndUpdate();
    SchedulerBinding.instance.addPostFrameCallback((_) =>
        scrollController.jumpTo(scrollController.position.maxScrollExtent));
  }

  /// Cancel the last [doAddScore] method call.
  void doCancel() {
    if (_cancelList.isEmpty) return;
    var player = _cancelList.removeLast();
    _table[player].removeLast();
    _writeAndUpdate();
  }

  /// Init [NewScreen] state
  void doInitNewGameState() {
    playersNew.clear();
    playersNew.addAll(players);
    playerNew = null;
  }

  /// Clear score table and cancel list, define players.
  void doNewGame() {
    players.clear();
    players.addAll(playersNew);
    _table.clear();
    _table.addAll(players.map((e) => <int>[]).toList().obs);
    _cancelList.clear();
    _writeAndUpdate(writePlayers: true);
  }

  /// [NewScreen] state : remove a player.
  void doRemovePlayer(int index) {
    playersNew.removeAt(index);
    update();
  }

  /// [NewScreen] state : reorder players.
  void doReorderPlayers(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = playersNew.removeAt(oldIndex);
    playersNew.insert(newIndex, item);
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

    // Read cancel list
    _cancelList.clear();
    List<int> cancelInt;
    var cancelRaw = _storage!.read(_cancelKey);
    if (cancelRaw is List) {
      cancelInt = cancelRaw.map((player) {
        return player as int;
      }).toList();
    } else {
      cancelInt = [];
    }
    _cancelList.addAll(cancelInt);
  }

  /// Write game state to persistent storage and update UI
  void _writeAndUpdate({bool writePlayers = false}) {
    _storage?.write(_tableKey, _table);
    if (writePlayers) _storage?.write(_playersKey, players);
    _storage?.write(_cancelKey, _cancelList);
    update();
  }
}
