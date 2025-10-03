import 'package:flutter/material.dart';
// import 'screens/example_buttons.dart';
// import 'screens/my_home_page.dart';
// import 'screens/product_list_screen.dart';
// import 'screens/custom_rich_text_screen.dart';
// import 'screens/app_buttons_screen.dart';
// import 'screens/flutter_course_screen.dart';
// import 'screens/gradient_buttons_screen.dart';
// import 'screens/button_showcase_screen.dart';
import 'screens/workout_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Course",
      home: const WorkoutScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
