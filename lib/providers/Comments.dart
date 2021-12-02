import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/comment.dart';

class Comments with ChangeNotifier {
  List<Comment> _items = [];
  final String? authToken;
  final String? userId;

  Comments(this.authToken, this.userId, this._items);

  List<Comment> get items {
    _items.sort((a, b) {
      return a.datetime!.compareTo(b.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetComments(String postId) async {
    final filterString = 'orderBy="postId"&equalTo="$postId"';
    var url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/comments.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Comment> loadedComments = [];
      extractedData.forEach((commentId, commentData) {
        loadedComments.add(Comment(
          id: commentId,
          contents: commentData['contents'],
          datetime: DateTime.parse(commentData['datetime'])
              .toUtc()
              .add(Duration(hours: 9)),
          postId: commentData['postId'],
          userId: commentData['creatorId'],
        ));
      });
      _items = loadedComments;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addComment(Comment comment) async {
    final url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/comments.json?auth=$authToken';
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'contents': comment.contents,
          'datetime': timeStamp.toIso8601String(),
          'postId': comment.postId,
          'creatorId': userId,
        }),
      );

      final newComment = Comment(
        contents: comment.contents,
        datetime: timeStamp,
        postId: comment.postId,
        userId: comment.userId,
        id: json.decode(response.body)['name'],
      );

      _items.add(newComment);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteComment(String id) async {
    final url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/comments/$id.json?auth=$authToken';

    final existingCommentIndex =
        _items.indexWhere((comment) => comment.id == id);
    Comment? existingComment = _items[existingCommentIndex];
    _items.removeAt(existingCommentIndex);
    //notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingCommentIndex, existingComment);
      notifyListeners();
      throw HttpException('Could not delete comment.');
    }
    _items.removeWhere((comment) => comment.id == id);
    notifyListeners();
    existingComment = null;
  }
}
