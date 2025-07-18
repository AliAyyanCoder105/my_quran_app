import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuaScreen extends StatelessWidget {
  final List<Map<String, String>> duaData = [
    {
      "title": "Dua Before Sleeping",
      "arabic": "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
      "translation": "In Your name, O Allah, I die and I live.",
    },
    {
      "title": "Dua After Waking Up",
      "arabic": "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
      "translation": "All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.",
    },
    {
      "title": "Dua Before Eating",
      "arabic": "بِسْمِ اللَّهِ",
      "translation": "In the name of Allah.",
    },
    {
      "title": "Dua After Eating",
      "arabic": "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ",
      "translation": "Praise to Allah Who has given us food and drink and made us Muslims.",
    },
    {
      "title": "Dua When Entering the Toilet",
      "arabic": "بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ",
      "translation": "In the name of Allah, O Allah, I seek refuge in you from the male and female evil spirits.",
    },
    {
      "title": "Dua When Leaving the Toilet",
      "arabic": "غُفْرَانَكَ",
      "translation": "I seek your forgiveness.",
    },
    {
      "title": "Dua When Entering Home",
      "arabic": "بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَىٰ رَبِّنَا تَوَكَّلْنَا",
      "translation": "In the name of Allah we enter, and in the name of Allah we leave, and upon our Lord we depend.",
    },
    {
      "title": "Dua When Leaving Home",
      "arabic": "بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
      "translation": "In the name of Allah, I trust in Allah; there is no might and no power but in Allah.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masnoon Duain'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A3A5F), Color(0xFF2E5F8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F)],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: duaData.length,
          itemBuilder: (context, index) {
            final dua = duaData[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              color: Color(0xFF1A3A5F).withOpacity(0.7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dua['title']!,
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(color: Colors.amber.withOpacity(0.5), height: 25),
                    Text(
                      dua["arabic"]!,
                      style: GoogleFonts.scheherazadeNew( // or GoogleFonts.notoNaskhArabic
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        height: 1.8, // Yeh line spacing improve karega
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl, // Yeh zaroori hai Arabic text ke liye
                    ),

                    SizedBox(height: 15),
                    Text(
                      dua['translation']!,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.4,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}