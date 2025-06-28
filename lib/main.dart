import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Islamic Hub',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Color(0xFF0C1E3A),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Scheherazade',
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1B5E20),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(), // The app now starts here
    );
  }
}