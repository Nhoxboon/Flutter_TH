import 'package:flutter/material.dart';
import 'screens/game_menu_screen.dart';
import 'screens/survey_station_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balance Ball Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SurveyStationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
