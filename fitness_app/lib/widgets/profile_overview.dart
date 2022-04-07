import 'package:firebase_auth/firebase_auth.dart';

import '../screens/rfm_screen.dart';

import '../screens/bmi_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final email = FirebaseAuth.instance.currentUser!.email;
    double? bmi = authData.bmi;
    double? rfm = authData.rfm;
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('RFM index'),
              style: ElevatedButton.styleFrom(primary: Colors.amber[400]),
              onPressed: () {
                Navigator.of(context).pushNamed(RfmScreen.routeName);
              },
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              child: const Text('BMI index'),
              style: ElevatedButton.styleFrom(primary: Colors.amber[400]),
              onPressed: () {
                Navigator.of(context).pushNamed(BmiScreen.routeName);
              },
            ),
          ],
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.email),
            title: email != null ? Text(email) : Text('Unable to get email')),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.calculate),
            title: bmi != null
                ? Text(bmi.toStringAsFixed(2))
                : const Text('Unable to get bmi')),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.calculate),
            title: rfm != null
                ? Text(rfm.toStringAsFixed(2))
                : const Text('Unable to get rfm')),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            // WidgetsBinding.instance!.addPostFrameCallback((_) {
            //   Navigator.of(context).pop();
            //   Navigator.of(context).pushReplacementNamed('/');
            // });

            // Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    );
  }
}
