import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './news.dart';

class NewsProvider with ChangeNotifier {
  List<News> _news = [];

  List<News> get news {
    return [..._news];
  }

  List<News> get epidemicNews {
    return _news.where((n) => n.category == 1).toList();
  }

  List<News> get trainingNews {
    return _news.where((n) => n.category == 2).toList();
  }

  Future<void> getEpedemic()async {
     _news=_news.where((n) => n.category == 0).toList();
  }

  Future<void> getTraining()async {
  _news=_news.where((n) => n.category == 1).toList();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse('http://10.0.2.2:5000/news');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List<dynamic>;
      print(extractedData);

      if (extractedData == null) {
        return;
      }
      final List<News> loadedNews = [];
      extractedData.forEach(
        (news) {
          loadedNews.add(
            News(
                id: news['id'],
                title: news['title'],
                newsInfo: news['newsInfo'],
                category: news['category'],
                createdAt: DateTime.parse(news['createdDate'])),
          );
        },
      );
      _news = loadedNews;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
