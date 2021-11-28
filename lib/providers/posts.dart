import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './post.dart';

class Posts with ChangeNotifier {
  List<Post> _items = [];
  final String? authToken;
  final String? userId;

  Posts(this.authToken, this.userId, this._items);

  List<Post> get items {
    return [..._items];
  }

  Future<void> fetchAndSetPosts(String boardId) async {
    final filterString = 'orderBy="boardId"&equalTo="$boardId"';
    var url = Uri.https('flutterforumdemoapp-default-rtdb.firebaseio.com',
        'posts.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Post> loadedPosts = [];
      extractedData.forEach((postId, postData) {
        loadedPosts.add(Post(
          id: postId,
          title: postData['title'],
          contents: postData['contents'],
          datetime: DateTime.parse(postData['datetime']),
          boardId: postData['boardId'],
          userId: postData['creatorId'],
        ));
      });
      _items = loadedPosts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addPost(Post post) async {
    final url = Uri.https('flutterforumdemoapp-default-rtdb.firebaseio.com',
        '/posts.json?auth=$authToken');
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': post.title,
          'contents': post.contents,
          'datetime': timeStamp.toIso8601String(),
          'boardId': post.boardId,
          'creatorId': post.userId,
        }),
      );

      final newPost = Post(
        title: post.title,
        contents: post.contents,
        datetime: timeStamp,
        boardId: post.boardId,
        userId: post.userId,
        id: json.decode(response.body)['name'],
      );

      _items.add(newPost);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updatePost(String id, Post newPost) async {}

  Future<void> deletePost(String id) async {}
}
