import 'package:flutter/material.dart';
import 'screens/gym_list_screen.dart'; 

void main() => runApp(const GymFinderApp());

class GymFinderApp extends StatelessWidget {
  const GymFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GymFinder',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.greenAccent,
        ),
      ),
      home: const GymListScreen(),
    );
  }
}
