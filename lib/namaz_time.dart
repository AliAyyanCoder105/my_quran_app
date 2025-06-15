import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class NamazTime extends StatefulWidget {
  @override
  _NamazTimeState createState() => _NamazTimeState();
}

class _NamazTimeState extends State<NamazTime> with SingleTickerProviderStateMixin {
  String fajrTime = 'Loading...';
  String dhuhrTime = 'Loading...';
  String asrTime = 'Loading...';
  String maghribTime = 'Loading...';
  String ishaTime = 'Loading...';
  String location = '';
  String date = '';
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _getNamazTimes();
    _getCurrentDate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getCurrentDate() async {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d, y');
    setState(() {
      date = formatter.format(now);
    });
  }

  Future<void> _getNamazTimes() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled. Please enable them.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permissions are denied.')),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are permanently denied. Please enable them in settings.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        location = "${place.locality}, ${place.administrativeArea}";
      });

      final now = DateTime.now();
      final year = now.year;
      final month = now.month;

      final url =
          'http://api.aladhan.com/v1/calendar/$year/$month?latitude=${position
          .latitude}&longitude=${position.longitude}&method=2';

      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final timings = jsonResponse['data'][now.day - 1]['timings'];

        setState(() {
          fajrTime = timings['Fajr'].toString().replaceAll(' (PKT)', '');
          dhuhrTime = timings['Dhuhr'].toString().replaceAll(' (PKT)', '');
          asrTime = timings['Asr'].toString().replaceAll(' (PKT)', '');
          maghribTime = timings['Maghrib'].toString().replaceAll(' (PKT)', '');
          ishaTime = timings['Isha'].toString().replaceAll(' (PKT)', '');
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to load prayer times. Please try again later. Status code: ${response.statusCode}')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'An error occurred: $e. Please check your internet connection.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildPrayerTimeCard(String prayerName, String time) {
    return ScaleTransition(
      scale: _animation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white.withOpacity(0.15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            Text(
              date,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Poppins',
              ),
            ),
          SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            )
                : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                _buildPrayerTimeCard('Fajr', fajrTime),
                SizedBox(height: 15),
                _buildPrayerTimeCard('Dhuhr', dhuhrTime),
                SizedBox(height: 15),
                _buildPrayerTimeCard('Asr', asrTime),
                SizedBox(height: 15),
                _buildPrayerTimeCard('Maghrib', maghribTime),
                SizedBox(height: 15),
                _buildPrayerTimeCard('Isha', ishaTime),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading ? null : _getNamazTimes, // Disable button while loading
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading ? Colors.grey : Colors.amber[700], // Grey out button while loading
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Refresh Times',
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