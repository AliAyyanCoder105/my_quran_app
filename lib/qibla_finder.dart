import 'dart:async';
import 'dart:math' show pi, cos, sin;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:vector_math/vector_math.dart' as math; // Keep for radians conversion

class QiblaFinderScreen extends StatefulWidget {
  @override
  _QiblaFinderScreenState createState() => _QiblaFinderScreenState();
}

class _QiblaFinderScreenState extends State<QiblaFinderScreen> {
  double? _compassHeading;
  StreamSubscription? _compassSubscription;

  @override
  void initState() {
    super.initState();
    // Start listening to compass events as soon as the screen loads
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _compassHeading = event.heading;
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up the subscription when the screen is closed
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compass'), // Changed title to 'Compass'
        backgroundColor: Color(0xFF1A3A5F),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F)],
          ),
        ),
        child: Center(
          child: _compassHeading == null
              ? CircularProgressIndicator(color: Colors.white)
              : _buildCompassUI(),
        ),
      ),
    );
  }

  Widget _buildCompassUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Current Heading",
          style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 24,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Text(
          "${_compassHeading!.toStringAsFixed(0)}°",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40),
        // The compass widget itself
        SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The rotating compass dial background
              AnimatedRotation(
                turns: -(_compassHeading! / 360),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: CustomPaint(
                  size: Size(320, 320),
                  painter: CompassPainter(),
                ),
              ),

              // The static needle that always points UP (representing North on the dial)
              Transform.rotate(
                angle: -pi / 2, // Rotate to point up
                child: Icon(
                  Icons.navigation,
                  size: 60,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter for the Compass Dial
class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, paint);

    // Ticks and letters
    final tickPaint = Paint()..strokeWidth = 2;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);

    for (int i = 0; i < 360; i += 15) {
      final angle = math.radians(i.toDouble());
      final isCardinal = i % 90 == 0;
      final isMajorTick = i % 30 == 0;

      final double tickLength = isCardinal ? 25.0 : (isMajorTick ? 15.0 : 8.0);
      final tickStart =
          center + Offset(cos(angle) * (radius), sin(angle) * (radius));
      final tickEnd = center +
          Offset(cos(angle) * (radius - tickLength),
              sin(angle) * (radius - tickLength));

      tickPaint.color = isCardinal
          ? Colors.amber
          : Colors.white.withOpacity(isMajorTick ? 0.7 : 0.4);
      canvas.drawLine(tickStart, tickEnd, tickPaint);

      if (isCardinal) {
        String direction;
        switch (i) {
          case 0: direction = 'E'; break;
          case 90: direction = 'S'; break;
          case 180: direction = 'W'; break;
          case 270: direction = 'N'; break;
          default: direction = '';
        }

        textPainter.text = TextSpan(text: direction, style: textStyle);
        textPainter.layout();
        final textOffset = center +
            Offset(cos(angle) * (radius - 50), sin(angle) * (radius - 50)) -
            Offset(textPainter.width / 2, textPainter.height / 2);
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}