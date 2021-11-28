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

  Future<void> fetchAndSetPosts(String boardId) async {}

  Future<void> addPost(Post post) async {}

  Future<void> updatePost(String id, Post newPost) async {}

  Future<void> deletePost(String id) async {}
}
