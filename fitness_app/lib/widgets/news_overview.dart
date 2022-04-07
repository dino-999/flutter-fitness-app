import 'package:fitness_app/providers/news_provider.dart';
import 'package:fitness_app/screens/news_detail.dart';
import 'package:fitness_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsOverview extends StatelessWidget {
  const NewsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsData = Provider.of<NewsProvider>(context);
    final news = newsData.news;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: news.length,
      itemBuilder: (ctx, i) => Card(
        elevation: 5,
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: news[i].category == 0
                ? Icon(
                    Icons.notification_important,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.notifications_active,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
          title: Text(
            news[i].title,
          ),
          subtitle: Text(
            news[i].newsInfo.substring(0, 20) + "...",
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 17,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(NewsDetailScreen.routeName, arguments: news[i]);
          },
        ),
      ),
    );
  }
}
