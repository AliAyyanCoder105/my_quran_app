import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model_99names.dart'; // Import the data file

class AsmaUlHusnaScreen extends StatefulWidget {
  @override
  _AsmaUlHusnaScreenState createState() => _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState extends State<AsmaUlHusnaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.forward();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
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
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F)],
          ),
        ),
        child: Stack(
          children: [
            // Parallax Background Pattern
            Positioned.fill(
              top: -_scrollOffset * 0.3,
              child: Opacity(
                opacity: 0.05,
                child: Image.asset('assets/islamic_pattern.png', repeat: ImageRepeat.repeat, fit: BoxFit.cover),
              ),
            ),
            CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                _buildHeader(),
                _buildNamesList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 50,
      title: Opacity(
        opacity: (_scrollOffset > 150) ? 1 : 0, // Title appears on scroll
        child: Text('Asma-ul-Husna',
            style: GoogleFonts.notoNastaliqUrdu(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          children: [
            Text(
              "أسماء الله الحسنى",
              style:
              GoogleFonts.scheherazadeNew( // or GoogleFonts.notoNaskhArabic
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                height: 1.8, // Yeh line spacing improve karega
              ),),
            SizedBox(height: 8),
            Text(
              "The 99 Beautiful Names of Allah",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final nameData = asmaUlHusnaData[index];
          return _buildAnimatedNameCard(index, nameData);
        },
        childCount: asmaUlHusnaData.length,
      ),
    );
  }

  Widget _buildAnimatedNameCard(int index, Map<String, String> nameData) {
    // Staggered animation for each card
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        (0.2 * (index / asmaUlHusnaData.length)), // Start animation progressively
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _NameCard(nameData: nameData),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({required this.nameData});

  final Map<String, String> nameData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A3A5F).withOpacity(0.8), Color(0xFF2E5F8A).withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Number Circle
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9D423), Color(0xFFFF4E50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  nameData['id']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            // Name and Meanings
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameData["arabic"]!,
                    style: GoogleFonts.scheherazadeNew( // or GoogleFonts.notoNaskhArabic
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      height: 1.8, // Yeh line spacing improve karega
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl, // Yeh zaroori hai Arabic text ke liye
                  ),


                  Divider(color: Colors.white.withOpacity(0.2), height: 20),
                  Text(
                    nameData['translation']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.85),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}