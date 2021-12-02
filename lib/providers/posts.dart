import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _items = [];
  final String? authToken;
  final String? userId;

  Posts(this.authToken, this.userId, this._items);

  List<Post> get items {
    _items.sort((a, b) {
      return b.datetime!.compareTo(a.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetPosts(String boardId) async {
    final filterString = 'orderBy="boardId"&equalTo="$boardId"';
    var url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/posts.json?auth=$authToken&$filterString';
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
    final url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/posts.json?auth=$authToken';
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

  Future<void> updatePost(String? id, Post newPost) async {
    final postIndex = _items.indexWhere((post) => post.id == id);
    if (postIndex >= 0) {
      final url =
          'https://flutterforumdemoapp-default-rtdb.firebaseio.com/posts/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newPost.title,
            'contents': newPost.contents,
          }));
      _items[postIndex] = newPost;
      notifyListeners();
    } else {
      print('Cannot find any post of id $id');
    }
  }

  Future<void> deletePost(String id) async {
    final url =
        'https://flutterforumdemoapp-default-rtdb.firebaseio.com/posts/$id.json?auth=$authToken';

    final existingPostIndex = _items.indexWhere((post) => post.id == id);
    Post? existingPost = _items[existingPostIndex];
    _items.removeAt(existingPostIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingPostIndex, existingPost);
      notifyListeners();
      throw HttpException('Could not delete post.');
    }
    _items.removeWhere((post) => post.id == id);
    notifyListeners();
    existingPost = null;
  }
}
