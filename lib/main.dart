import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/screens/group_detail_screen.dart';
import 'package:reminder_app/screens/home.dart';

import 'screens/mylists_detail_screen.dart';

import 'providers/lists.dart';
import 'providers/reminders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (ctx) => Lists()),
          ChangeNotifierProvider(
              create: (ctx) => Reminders())
        ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 26,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
          ),
          titleSmall: const TextStyle(
            fontSize: 14
          ),
          headlineLarge: const TextStyle(
              fontSize: 22,
              color: CupertinoColors.black,
              fontWeight: FontWeight.w600
          ),
          headlineMedium: const TextStyle(
            fontSize: 20,
          ),
          headlineSmall: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor
          ),
        )
      ),
      home: MyHomePage(),
      routes: {
        MyHomePage.routeName : (context) => MyHomePage(),
        MylistsDetailScreen.routeName : (context) =>  const MylistsDetailScreen(),
        GroupDetailScreen.routeName : (context) => GroupDetailScreen()
      },
    )
    );
  }
}

