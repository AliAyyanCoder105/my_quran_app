import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NamazTime extends StatefulWidget {
  @override
  _NamazTimeState createState() => _NamazTimeState();
}
//
class _NamazTimeState extends State<NamazTime> with SingleTickerProviderStateMixin {
  String fajrTime = 'Loading...';
  String sunriseTime = 'Loading...';
  String dhuhrTime = 'Loading...';
  String asrTime = 'Loading...';
  String maghribTime = 'Loading...';
  String ishaTime = 'Loading...';
  String location = 'Getting location...';
  String date = '';
  bool isLoading = true;
  bool locationError = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _colorAnimation = ColorTween(
      begin: Color(0xFF0C1E3A),
      end: Color(0xFF2E5F8A),
    ).animate(_controller);

    _controller.repeat(reverse: true);
    _getCurrentDate();
    _getLocationAndPrayerTimes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getCurrentDate() async {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d, y', 'ar');
    setState(() {
      date = formatter.format(now);
    });
  }

  Future<void> _getLocationAndPrayerTimes() async {
    setState(() {
      isLoading = true;
      locationError = false;
    });

    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions permanently denied');
      }

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = placemarks.first.locality ?? placemarks.first.subAdministrativeArea ?? '';
      String country = placemarks.first.country ?? '';

      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/timings/${DateFormat('dd-MM-yyyy').format(DateTime.now())}?latitude=${position.latitude}&longitude=${position.longitude}&method=2'
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        setState(() {
          fajrTime = _formatTime(timings['Fajr']);
          sunriseTime = _formatTime(timings['Sunrise']);
          dhuhrTime = _formatTime(timings['Dhuhr']);
          asrTime = _formatTime(timings['Asr']);
          maghribTime = _formatTime(timings['Maghrib']);
          ishaTime = _formatTime(timings['Isha']);
          location = '$city, $country'.trim();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        locationError = true;
        location = 'Unable to get location';
        isLoading = false;
      });

      // Fallback to manual city selection
      _showCitySelectionDialog();
    }
  }

  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts[1];

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : hour;

      return '$displayHour:$minute $period';
    } catch (e) {
      return time; // Return original if formatting fails
    }
  }

  void _showCitySelectionDialog() {
    final cities = {
      'Makkah': {'lat': 21.3891, 'lng': 39.8579},
      'Madinah': {'lat': 24.5247, 'lng': 39.5692},
      'Cairo': {'lat': 30.0444, 'lng': 31.2357},
      'Dubai': {'lat': 25.2048, 'lng': 55.2708},
      'Istanbul': {'lat': 41.0082, 'lng': 28.9784},
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select City'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: cities.keys.map((city) => ListTile(
            title: Text(city),
            onTap: () {
              Navigator.pop(context);
              _fetchPrayerTimesForCity(cities[city]!['lat']!, cities[city]!['lng']!, city);
            },
          )).toList(),
        ),
      ),
    );
  }

  Future<void> _fetchPrayerTimesForCity(double lat, double lng, String cityName) async {
    setState(() {
      isLoading = true;
      location = cityName;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/timings/${DateFormat('dd-MM-yyyy').format(DateTime.now())}?latitude=$lat&longitude=$lng&method=2'
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        setState(() {
          fajrTime = _formatTime(timings['Fajr']);
          sunriseTime = _formatTime(timings['Sunrise']);
          dhuhrTime = _formatTime(timings['Dhuhr']);
          asrTime = _formatTime(timings['Asr']);
          maghribTime = _formatTime(timings['Maghrib']);
          ishaTime = _formatTime(timings['Isha']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      setState(() {
        fajrTime = 'Error';
        dhuhrTime = 'Error';
        asrTime = 'Error';
        maghribTime = 'Error';
        ishaTime = 'Error';
        isLoading = false;
      });
    }
  }

  Widget _buildPrayerTimeCard(String prayerName, String time, IconData icon) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 10),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: _colorAnimation.value,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF9D423), Color(0xFFFF4E50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prayerName,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Scheherazade',
                            ),
                          ),
                          if (location.isNotEmpty && prayerName == 'Fajr')
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Poppins',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.amber[300],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (date.isNotEmpty)
            FadeTransition(
              opacity: _animation,
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                strokeWidth: 5,
              ),
            )
                : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                _buildPrayerTimeCard('Fajr', fajrTime, Icons.nightlight_round),
                SizedBox(height: 10),
                _buildPrayerTimeCard('Sunrise', sunriseTime, Icons.wb_sunny),
                SizedBox(height: 10),
                _buildPrayerTimeCard('Dhuhr', dhuhrTime, Icons.wb_sunny),
                SizedBox(height: 10),
                _buildPrayerTimeCard('Asr', asrTime, Icons.brightness_5),
                SizedBox(height: 10),
                _buildPrayerTimeCard('Maghrib', maghribTime, Icons.brightness_4),
                SizedBox(height: 10),
                _buildPrayerTimeCard('Isha', ishaTime, Icons.bedtime),
                if (locationError)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Using default location. Tap to change city.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.amber,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: isLoading ? null : _getLocationAndPrayerTimes,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              elevation: 5,
              shadowColor: Colors.amber.withOpacity(0.5),
            ),
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 24,
            ),
            label: Text(
              'تحديث الأوقات',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}