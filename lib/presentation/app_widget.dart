import 'package:flutter/material.dart';
import 'package:music_player_with_getx/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: ThemeData(
        useMaterial3: true
      ),
      home: const HomePage(),
    );
  }
}