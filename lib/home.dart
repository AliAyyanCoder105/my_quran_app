import 'package:dart/quran.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:math';

// Import all your feature screens
import '99names_of_allah.dart';
import 'important_dua.dart';
import 'islamic_calender.dart';
import 'kalmaat.dart';

import 'namaz_time.dart';

import 'tasbeeh_counter.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  final List<Map<String, String>> dailyVerses = [
    {"arabic": "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا", "translation": "So, surely with hardship comes ease.", "surah": "Ash-Sharh, 94:5"},
    {"arabic": "وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ", "translation": "And whoever relies upon Allah - then He is sufficient for him.", "surah": "At-Talaq, 65:3"},
    {"arabic": "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ", "translation": "Unquestionably, by the remembrance of Allah hearts are assured.", "surah": "Ar-Ra'd, 13:28"},
    {"arabic": "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا", "translation": "Allah does not burden a soul beyond that it can bear.", "surah": "Al-Baqarah, 2:286"}
  ];

  late Map<String, String> _verseOfTheDay;
  late String _hijriDate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _verseOfTheDay = dailyVerses[Random().nextInt(dailyVerses.length)];
    var hijri = HijriCalendar.now();
    _hijriDate = hijri.toFormat("dd MMMM yyyy");

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F), Color(0xFF2E5F8A)],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: Stack(
          children: [
            // Parallax Background Elements
            Positioned(
              top: -80 - (_scrollOffset * 0.3),
              right: -80,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.mosque, size: 350, color: Colors.white),
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          _buildAnimatedHeader(),
                          SizedBox(height: 30),
                          _buildVerseOfTheDayCard(),
                          SizedBox(height: 30),
                          _buildSectionHeader(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _buildAnimatedGrid(),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return _buildAnimatedWidget(
      interval: Interval(0.0, 0.5, curve: Curves.easeOut),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'As-salamu alaykum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _hijriDate,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseOfTheDayCard() {
    return _buildAnimatedWidget(
      interval: Interval(0.2, 0.7, curve: Curves.easeOut),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E5F8A).withOpacity(0.9), Color(0xFF1A3A5F).withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Subtle Islamic Pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Image.asset('assets/islamic_pattern.png', repeat: ImageRepeat.repeat, fit: BoxFit.cover),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verse of the Day",
                      style: TextStyle(color: Colors.amber[300], fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.white.withOpacity(0.2), height: 25),
                    Text(
                      _verseOfTheDay['arabic']!,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.scheherazadeNew( // or GoogleFonts.notoNaskhArabic
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        height: 1.8, // Yeh line spacing improve karega
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _verseOfTheDay['translation']!,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _verseOfTheDay['surah']!,
                      style: TextStyle(color: Colors.amber[300], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return _buildAnimatedWidget(
      interval: Interval(0.4, 0.9, curve: Curves.easeOut),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          "Explore Features",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAnimatedGrid() {
    final features = [
      {'icon': Icons.book_outlined, 'title': 'Quran Majeed', 'screen': QuranApp()},
      {'icon': Icons.access_time_filled_outlined, 'title': 'Prayer Times', 'screen': NamazTimeScreen()},
      {'icon': Icons.star_outline, 'title': 'Six Kalmas', 'screen': KalmaScreen()},
      {'icon': Icons.shield_outlined, 'title': 'Masnoon Duain', 'screen': DuaScreen()},

      {'icon': Icons.fingerprint, 'title': 'Tasbeeh', 'screen': TasbeehCounterScreen()},
      {'icon': Icons.favorite_border, 'title': '99 Names', 'screen': AsmaUlHusnaScreen()},
      {'icon': Icons.calendar_month_outlined, 'title': 'Hijri Calendar', 'screen': IslamicCalendarScreen()},
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final feature = features[index];
            return _buildAnimatedFeatureCard(
              interval: Interval(0.5 + (index * 0.05), 1.0, curve: Curves.easeOut),
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
              onTap: () => _navigateTo(context, feature['screen'] as Widget),
            );
          },
          childCount: features.length,
        ),
      ),
    );
  }

  Widget _buildAnimatedFeatureCard({required Interval interval, required IconData icon, required String title, required VoidCallback onTap}) {
    return _buildAnimatedWidget(
      interval: interval,
      child: _FeatureCard(
          icon: icon,
          title: title,
          onTap: onTap
      ),
    );
  }

  Widget _buildAnimatedWidget({required Widget child, required Interval interval}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final animationValue = interval.transform(_controller.value);
        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(0, (1 - animationValue) * 30),
            child: child,
          ),
        );
      },
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({required this.icon, required this.title, required this.onTap});

  @override
  __FeatureCardState createState() => __FeatureCardState();
}

class __FeatureCardState extends State<_FeatureCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      onTap: () async {
        setState(() => _isTapped = true);
        await Future.delayed(const Duration(milliseconds: 150));
        widget.onTap();
        setState(() => _isTapped = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _isTapped ? (Matrix4.identity()..scale(0.95)) : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A3A5F).withOpacity(0.8), Color(0xFF2E5F8A).withOpacity(0.9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9D423), Color(0xFFFF4E50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: Colors.white, size: 30),
            ),
            SizedBox(height: 12),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// Wrapper screen for NamazTime (no changes needed here)
class NamazTimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("أوقات الصلاة"),
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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F), Color(0xFF2E5F8A)],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(child: NamazTime()),
      ),
    );
  }
}