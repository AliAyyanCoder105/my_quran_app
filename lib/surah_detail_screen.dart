import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class SurahDetailScreen extends StatefulWidget {
  final String surahName;
  final int surahIndex;

  const SurahDetailScreen({
    required this.surahName,
    required this.surahIndex,
    Key? key,
  }) : super(key: key);

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double _playbackSpeed = 1.0;
  List<Map<String, String>> currentSurah = [];
  String _searchText = '';

  late String fullSurahAudioUrl;

  @override
  void initState() {
    super.initState();
    fetchSurah(widget.surahIndex + 1);

    // Full surah audio from mp3quran.net (Mishary Rashid Alafasy)
    fullSurahAudioUrl =
    "https://server8.mp3quran.net/afs/${(widget.surahIndex + 1).toString().padLeft(3, '0')}.mp3";
  }

  Future<void> fetchSurah(int surahNumber) async {
    final url =
        'https://api.alquran.cloud/v1/surah/$surahNumber/editions/ar.alafasy,en.sahih';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Map<String, String>> loadedSurah = [];

        final arabicAyahs = data['data'][0]['ayahs'];
        final englishAyahs = data['data'][1]['ayahs'];

        for (int i = 0; i < arabicAyahs.length; i++) {
          loadedSurah.add({
            "arabic": arabicAyahs[i]['text'],
            "translation": englishAyahs[i]['text'],
          });
        }

        setState(() {
          currentSurah = loadedSurah;
        });
      } else {
        throw Exception('Failed to load surah');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load surah data')),
      );
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playFullSurah() async {
    if (isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
      return;
    }

    try {
      setState(() {
        isPlaying = true;
      });

      await audioPlayer.setPlaybackRate(_playbackSpeed);
      await audioPlayer.play(UrlSource(fullSurahAudioUrl));

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
        });
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio')),
      );
    }
  }

  void _showPlaybackSpeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A3A5F),
          title: const Text(
            'Playback Speed',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _playbackSpeed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 3,
                    label: _playbackSpeed.toStringAsFixed(1),
                    activeColor: Colors.amber,
                    inactiveColor: Colors.amber.withOpacity(0.3),
                    onChanged: (value) {
                      setState(() {
                        _playbackSpeed = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_playbackSpeed.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL', style: TextStyle(color: Colors.amber)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('APPLY', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                if (isPlaying) {
                  audioPlayer.setPlaybackRate(_playbackSpeed);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSurah = currentSurah.where((ayah) =>
    ayah['arabic']!.contains(_searchText) ||
        ayah['translation']!
            .toLowerCase()
            .contains(_searchText.toLowerCase()));

    return Scaffold(
      backgroundColor: const Color(0xFF0C1E3A),
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: const TextStyle(
            fontFamily: 'Scheherazade',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A3A5F), Color(0xFF2E5F8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.speed),
            onPressed: _showPlaybackSpeedDialog,
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.amber,
              size: 30,
            ),
            onPressed: playFullSurah,
          ),
        ],
      ),
      body: currentSurah.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search translation...',
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon:
                const Icon(Icons.search, color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredSurah.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.2),
                height: 30,
              ),
              itemBuilder: (context, index) {
                final ayah = filteredSurah.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1A3A5F).withOpacity(0.7),
                            const Color(0xFF2E5F8A).withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ayah["arabic"]!,
                        style: GoogleFonts.scheherazadeNew(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1A3A5F).withOpacity(0.7),
                            const Color(0xFF2E5F8A).withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ayah["translation"] ??
                            "Translation not available",
                        style: TextStyle(
                          fontSize:
                          MediaQuery.of(context).size.width * 0.045,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Poppins',
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
