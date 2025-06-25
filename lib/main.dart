import 'package:dart/quran.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holy Quran',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
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
      home: QuranHomeScreen(),
    );
  }
}

class QuranHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C1E3A), // Dark blue
              Color(0xFF1A3A5F), // Medium blue
              Color(0xFF2E5F8A), // Light blue
            ],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.mosque,
                  size: 300,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.book,
                  size: 250,
                  color: Colors.white,
                ),
              ),
            ),
            SafeArea(
              child: QuranApp(),
            ),
          ],
        ),
      ),
    );
  }
}