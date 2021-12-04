import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:first_app/models/board.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Board_List with ChangeNotifier {
  final String? authToken;
  List<Board> _items = [];
  Board_List(this.authToken, this._items);

  List<Board> get items {
    return [..._items];
  }

  Future<void> fetchAndSetBoards() async {
    var url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/boards.json?auth=$authToken';
    print(url);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Board> loadedBoards = [];
      extractedData.forEach((boardId, boardData) {
        loadedBoards.add(Board(boardId, boardData['name']));
      });
      _items = loadedBoards;
      print(this.items);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
