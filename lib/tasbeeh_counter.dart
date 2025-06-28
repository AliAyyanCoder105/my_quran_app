import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TasbeehCounterScreen extends StatefulWidget {
  @override
  _TasbeehCounterScreenState createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  final int _target = 33;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _selectedDhikr = "SubhanAllah"; // Default Dhikr

  final List<String> _dhikrList = [
    "SubhanAllah",        // Glory be to Allah
    "Alhamdulillah",      // Praise be to Allah
    "Allahu Akbar",       // Allah is the Greatest
    "La ilaha illallah",  // There is no god but Allah
    "Astaghfirullah",     // I seek forgiveness from Allah
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() async {
    // Vibrate on tap
    if (await Vibration.hasVibrator() ?? false) {
      if (_counter + 1 == _target) {
        // Longer vibration for reaching the target
        Vibration.vibrate(duration: 200);
      } else {
        Vibration.vibrate(duration: 20, amplitude: 128);
      }
    }

    setState(() {
      _counter++;
    });

    // Animate the button press
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _showDhikrSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A3A5F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
          itemCount: _dhikrList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _dhikrList[index],
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _selectedDhikr = _dhikrList[index];
                  _resetCounter();
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasbeeh Counter'),
        backgroundColor: Color(0xFF1A3A5F),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDhikrDisplay(),
            _buildCounterDisplay(),
            _buildCounterButton(),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrDisplay() {
    return InkWell(
      onTap: _showDhikrSelection,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedDhikr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterDisplay() {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            '$_counter',
            key: ValueKey<int>(_counter),
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ),
        Text(
          '/ $_target',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _incrementCounter,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF9D423), Color(0xFFFF4E50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF4E50).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: Center(
            child: Icon(
              Icons.touch_app,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return IconButton(
      icon: Icon(Icons.refresh, color: Colors.white.withOpacity(0.8), size: 35),
      onPressed: _resetCounter,
    );
  }
}