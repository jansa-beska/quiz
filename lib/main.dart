import 'package:flutter/material.dart';
import 'package:quiz/features/home/home_screen.dart';
import 'package:quiz/features/premium/premium_screen.dart';
import 'package:quiz/features/success_and_lose/lose_screen.dart';
import 'package:quiz/features/success_and_lose/success_screen.dart';
import 'package:quiz/features/tutorial/tutorial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        primarySwatch: Colors.blue,
      ),
      home: const TutorialScreen(),
    );
  }
}
