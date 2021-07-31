import 'dart:convert';
import 'dart:math';

import 'package:localstorage/localstorage.dart';

class Game {
  final String ID;

  final List<String> players;

  final List<List<int>> table;
  final List<int> _cancelList = [];

  Game(this.ID, this.players) : table = players.map((e) => <int>[]).toList();

  get cancelable => _cancelList.length > 0;

  get count => max(table[0].length, table[1].length);

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

  final _storage = LocalStorage('points.json');

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

  Future<void> writeAll() async {
    await _storage.ready;
    await _storage.setItem('modele', json.encode(table));
  }

  Future ctrlAddScore(int player, int score) async {
    _cancelList.add(player);
    var list = table[player];
    var length = list.length;
    list.add(length == 0 ? score : list[length - 1] + score);
    await writeAll();
  }

  void ctrlCancel() async {
    if (_cancelList.length == 0) return;
    var player = _cancelList.removeLast();
    table[player].removeLast();
    await writeAll();
  }

  void ctrlRAZ() {
    table.clear();
    _cancelList.clear();
  }
}
