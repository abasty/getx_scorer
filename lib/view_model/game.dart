import 'dart:convert';
import 'dart:math';

import 'package:localstorage/localstorage.dart';

/// A game defined by an [ID] and a list of [players].
class Game {
  /// The [ID] of the game.
  final String ID;

  /// List of players (names).
  final List<String> players;

  /// List of score columns. Each column is linked with a player in the
  /// [players] list.
  final List<List<int>> table;

  final List<int> _cancelList = [];

  final _storage = LocalStorage('points.json');

  /// Create a new game given an ID and a list of players.
  Game(this.ID, this.players) : table = players.map((e) => <int>[]).toList();

  /// [cancelable] is true iff the cancel list is not empty.
  get cancelable => _cancelList.isNotEmpty;

  /// [count] is the maximum number of elements in all columns.
  get count => table.map((c) => c.length).reduce(max);

  /// Add a score to the player score column.
  Future ctrlAddScore(int player, int score) async {
    _cancelList.add(player);
    var list = table[player];
    var length = list.length;
    list.add(length == 0 ? score : list[length - 1] + score);
    await writeAll();
  }

  /// Cancel the last [ctrlAddScore] method call.
  Future ctrlCancel() async {
    if (_cancelList.length == 0) return;
    var player = _cancelList.removeLast();
    table[player].removeLast();
    await writeAll();
  }

  /// Empty score table and cancel list.
  void ctrlRAZ() {
    table.clear();
    _cancelList.clear();
  }

  /// Gets a player line of score. Returns two values : the absolute score value
  /// for the line and the delta with the previous line.
  List<int> getScore(int player, int line) {
    var length = table[player].length;
    if (line >= length) return [-1, 0];
    return [
      table[player][line],
      line == 0
          ? table[player][line]
          : table[player][line] - table[player][line - 1]
    ];
  }

  /// Read score table from file.
  Future<void> readAll() async {
    await _storage.ready;
    var map = json.decode(await _storage.getItem('modele') as String);
    List<List<int>> tmp;
    table.clear();
    if (map is List) {
      tmp = map
          .map<List<int>>((j) =>
              j is List ? j.map<int>((p) => p is int ? p : 0).toList() : [])
          .toList();
    } else {
      tmp = players.map((e) => <int>[]).toList();
    }
    table.addAll(tmp);
  }

  /// Write the score table to a file.
  Future<void> writeAll() async {
    await _storage.ready;
    await _storage.setItem('modele', json.encode(table));
  }
}
