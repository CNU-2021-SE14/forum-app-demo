import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Post with ChangeNotifier {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? boardId;
  final String? userId;

  Post(
      {this.id,
      this.title,
      this.contents,
      this.datetime,
      this.boardId,
      this.userId});
}
