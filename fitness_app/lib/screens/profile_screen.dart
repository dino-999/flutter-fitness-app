import 'package:flutter/material.dart';
import '../widgets/profile_overview.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Fitness App')),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const ProfileOverview(),
    );
  }
}
