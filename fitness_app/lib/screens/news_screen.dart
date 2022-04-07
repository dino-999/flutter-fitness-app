import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/news_overview.dart';
import '../screens/profile_screen.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = '/news';
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<NewsProvider>(context, listen: false).fetchNews();
  }

  Future<void> _refreshEpedemic(BuildContext context) async {
    await Provider.of<NewsProvider>(context, listen: false).getEpedemic();
  }

  Future<void> _refreshTraining(BuildContext context) async {
    await Provider.of<NewsProvider>(context, listen: false).getTraining();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<NewsProvider>(context, listen: false).fetchNews().then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('News')),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [const Text('Sve vijesti')],
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [const Text('Epidemiološke vijesti')],
                  ),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [const Text('Vijesti o treninzima')],
                  ),
                  value: 3,
                )
              ],
              onSelected: (value) {
                if (value == 1) {
                  _refreshProducts(context);
                }
                if (value == 2) {
                  _refreshEpedemic(context);
                }
                if (value == 3) {
                  _refreshTraining(context);
                }
                print(value);
              },
            ),
          ]),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.amber,
            ))
          : RefreshIndicator(
              color: Colors.amber,
              onRefresh: () => _refreshProducts(context),
              child: const NewsOverview(),
            ),
    );
  }
}
