import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class News {
  String id;
  String title;
  String newsInfo;
  int category;
  DateTime createdAt;

  News(
      {required this.id,
      required this.title,
      required this.newsInfo,
      required this.category,
      required this.createdAt});
}
