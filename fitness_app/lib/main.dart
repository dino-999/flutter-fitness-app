import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/providers/training_dates_provider.dart';

import './screens/rfm_screen.dart';

import './screens/bmi_screen.dart';

import './screens/news_detail.dart';

import './screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './screens/news_screen.dart';
import './screens/auth_screen.dart';

import './screens/home_screen.dart';

import './screens/profile_screen.dart';
import './providers/news_provider.dart';
import './providers/auth.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => TrainingDatesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FlutterChat',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              backgroundColor: Colors.blueGrey,
              accentColor: Colors.amber,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.amber,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return HomeScreen();
                      }
                      return AuthScreen();
                    }),
            routes: {
              NewsScreen.routeName: (ctx) => NewsScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              NewsDetailScreen.routeName: (ctx) => NewsDetailScreen(),
              BmiScreen.routeName: (ctx) => BmiScreen(),
              RfmScreen.routeName: (ctx) => RfmScreen(),
            },
          );
        });
    // return Consumer<Auth>(
    //   builder: (ctx, auth, _) => MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'Fitness App',
    //     theme: ThemeData(
    //       fontFamily: 'Lato',

    //       primarySwatch: Colors.blueGrey,
    //       backgroundColor: Colors.blueGrey,
    //       accentColor: Colors.amber,
    //       accentColorBrightness: Brightness.dark,
    //       buttonTheme: ButtonTheme.of(context).copyWith(
    //         buttonColor: Colors.amber,
    //         textTheme: ButtonTextTheme.primary,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(20),
    //         ),
    //     ),
    //     ),
    //     home: auth.isAuth
    //         ? HomeScreen()
    //         : FutureBuilder(
    //             future: auth.tryAutoLogin(),
    //             builder: (ctx, authResultSnapshot) =>
    //                 authResultSnapshot.connectionState ==
    //                         ConnectionState.waiting
    //                     ? SplashScreen()
    //                     : AuthScreen()),
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
