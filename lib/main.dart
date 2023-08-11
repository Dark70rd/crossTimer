import 'package:flutter/material.dart';
import 'package:ctimer_prototype_1/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CountDown Timer App",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Fjalla-One',
      ),
      home: const HomePage(),
    );
  }
}
