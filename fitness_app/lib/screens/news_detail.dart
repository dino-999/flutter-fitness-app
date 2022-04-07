import 'package:intl/intl.dart';

import '../providers/news.dart';
import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  static const routeName = '/newsDetail';
  const NewsDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = ModalRoute.of(context)!.settings.arguments as News;

    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
              child: Text(
                DateFormat.yMMMMd().format(news.createdAt),
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
               news.newsInfo,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
