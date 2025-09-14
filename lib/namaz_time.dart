import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:blurrycontainer/blurrycontainer.dart'; // For the glass effect

class NamazTime extends StatefulWidget {
  @override
  _NamazTimeState createState() => _NamazTimeState();
}

class _NamazTimeState extends State<NamazTime> {
  String fajrTime = '...';
  String sunriseTime = '...';
  String dhuhrTime = '...';
  String asrTime = '...';
  String maghribTime = '...';
  String ishaTime = '...';
  String location = 'Detecting Location...';
  String date = '';
  bool isLoading = true;
  bool locationError = false;

  @override
  void initState() {
    super.initState();
    _getCurrentDate();
    _getLocationAndPrayerTimes();
  }

  Future<void> _getCurrentDate() async {
    final now = DateTime.now();
    // A more elegant date format
    final formatter = DateFormat('EEEE, MMMM d');
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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. We cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      String city = placemarks.first.locality ?? 'Unknown City';
      String country = placemarks.first.country ?? 'Unknown Country';

      await _fetchPrayerTimes(position.latitude, position.longitude, '$city, $country');

    } catch (e) {
      print('Error: $e');
      setState(() {
        locationError = true;
        location = 'Could not get location';
        isLoading = false;
      });
      _showCitySelectionDialog();
    }
  }

  // A robust function to format time from "HH:mm" to "h:mm a"
  String _formatTime(String time) {
    try {
      final hour = int.parse(time.substring(0, 2));
      final minute = int.parse(time.substring(3, 5));
      final timeOfDay = TimeOfDay(hour: hour, minute: minute);
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return time; // Return original if formatting fails
    }
  }

  Future<void> _fetchPrayerTimes(double lat, double lng, String locationName) async {
    setState(() {
      isLoading = true;
      location = locationName;
    });

    final dateString = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final uri = Uri.parse(
        'http://api.aladhan.com/v1/timings/$dateString?latitude=$lat&longitude=$lng&method=2');

    try {
      final response = await http.get(uri);
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
          locationError = false;
        });
      } else {
        throw Exception('Failed to load prayer times from the API.');
      }
    } catch (e) {
      setState(() {
        fajrTime = 'Error';
        dhuhrTime = 'Error';
        asrTime = 'Error';
        maghribTime = 'Error';
        ishaTime = 'Error';
        isLoading = false;
        locationError = true;
      });
    }
  }

  void _showCitySelectionDialog() {
    final cities = {
      'Makkah': {'lat': 21.3891, 'lng': 39.8579},
      'Madinah': {'lat': 24.5247, 'lng': 39.5692},
      'Cairo': {'lat': 30.0444, 'lng': 31.2357},
      'Dubai': {'lat': 25.2048, 'lng': 55.2708},
      'Istanbul': {'lat': 41.0082, 'lng': 28.9784},
      'Lahore': {'lat': 31.5820, 'lng': 74.3294},
      'Karachi': {'lat': 24.8607, 'lng': 67.0011},
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1D2A41).withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Select a City', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: cities.keys.map((city) => ListTile(
              title: Text(city, style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _fetchPrayerTimes(cities[city]!['lat']!, cities[city]!['lng']!, city);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeCard(String prayerName, String time, IconData icon, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: BlurryContainer(
            // ----- START OF FIX -----
            // Instead of a 'decoration' property, we use these directly:
            blur: 5,
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),

            // ----- END OF FIX -----

            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.amber[300], size: 28),
                    SizedBox(width: 20),
                    Text(
                      prayerName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.amber[300],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0C1E3A),
              Color(0xFF1D2A41),
              Color(0xFF2E5F8A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                // --- Header ---
                Text(
                  location,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black38)],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 30),

                // --- Prayer Times List ---
                Expanded(
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  )
                      : AnimationLimiter(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        _buildPrayerTimeCard('Fajr', fajrTime, Icons.nightlight_round, 0),
                        SizedBox(height: 12),
                        _buildPrayerTimeCard('Sunrise', sunriseTime, Icons.wb_sunny_outlined, 1),
                        SizedBox(height: 12),
                        _buildPrayerTimeCard('Dhuhr', dhuhrTime, Icons.wb_sunny, 2),
                        SizedBox(height: 12),
                        _buildPrayerTimeCard('Asr', asrTime, Icons.filter_drama_outlined, 3),
                        SizedBox(height: 12),
                        _buildPrayerTimeCard('Maghrib', maghribTime, Icons.wb_twilight_outlined, 4),
                        SizedBox(height: 12),
                        _buildPrayerTimeCard('Isha', ishaTime, Icons.bedtime_outlined, 5),
                      ],
                    ),
                  ),
                ),

                // --- Footer / Refresh Button ---
                if (locationError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Could not get location. Select a city.',
                      style: TextStyle(color: Colors.amber[300]),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _getLocationAndPrayerTimes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      elevation: 8,
                      shadowColor: Colors.amber.withOpacity(0.5),
                    ),
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      'تحديث',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}