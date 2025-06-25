import 'package:audioplayers/audioplayers.dart' show AudioPlayer, UrlSource;
import 'package:flutter/material.dart';

class SurahDetailScreen extends StatefulWidget {
  final String surahName;
  final int surahIndex;

  SurahDetailScreen({required this.surahName, required this.surahIndex});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentPlayingAyah = -1;
  double _playbackSpeed = 1.0;

  // Sample Quran data structure
  final List<List<Map<String, String>>> quranData = [
    // Surah Al-Fatiha (example with 7 verses)
    [
      {
        "arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
        "audio": "https://server1.mp3quran.net/afs/001.mp3"
      },
      {
        "arabic": "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
        "translation": "[All] praise is [due] to Allah, Lord of the worlds -",
        "audio": "https://server1.mp3quran.net/afs/002.mp3"
      },
      {
        "arabic": "الرَّحْمَٰنِ الرَّحِيمِ",
        "translation": "The Entirely Merciful, the Especially Merciful,",
        "audio": "https://server1.mp3quran.net/afs/003.mp3"
      },
      {
        "arabic": "مَالِكِ يَوْمِ الدِّينِ",
        "translation": "Sovereign of the Day of Recompense.",
        "audio": "https://server1.mp3quran.net/afs/004.mp3"
      },
      {
        "arabic": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
        "translation": "It is You we worship and You we ask for help.",
        "audio": "https://server1.mp3quran.net/afs/005.mp3"
      },
      {
        "arabic": "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
        "translation": "Guide us to the straight path -",
        "audio": "https://server1.mp3quran.net/afs/006.mp3"
      },
      {
        "arabic": "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
        "translation": "The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.",
        "audio": "https://server1.mp3quran.net/afs/007.mp3"
      }
    ],
    // Add more surahs here following the same pattern
  ];

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAyah(int index) async {
    if (currentPlayingAyah == index && isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
        currentPlayingAyah = -1;
      });
      return;
    }

    final ayahData = quranData[widget.surahIndex][index];
    if (ayahData["audio"] == null || ayahData["audio"]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio not available for this verse')),
      );
      return;
    }

    try {
      setState(() {
        currentPlayingAyah = index;
        isPlaying = true;
      });

      await audioPlayer.setPlaybackRate(_playbackSpeed);
      await audioPlayer.play(UrlSource(ayahData["audio"]!));

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
          currentPlayingAyah = -1;
        });
      });

    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        isPlaying = false;
        currentPlayingAyah = -1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  void _showPlaybackSpeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A3A5F),
          title: Text(
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
                  SizedBox(height: 10),
                  Text(
                    '${_playbackSpeed.toStringAsFixed(1)}x',
                    style: TextStyle(
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
              child: Text('CANCEL', style: TextStyle(color: Colors.amber)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('APPLY', style: TextStyle(color: Colors.amber)),
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
    List<Map<String, String>> currentSurah = [];
    if (widget.surahIndex < quranData.length) {
      currentSurah = quranData[widget.surahIndex];
    } else {
      currentSurah = [
        {"arabic": "لا توجد بيانات", "translation": "No Data Available", "audio": ""}
      ];
    }

    return Scaffold(
      backgroundColor: Color(0xFF0C1E3A),
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: TextStyle(
            fontFamily: 'Scheherazade',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A3A5F), Color(0xFF2E5F8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.speed),
            onPressed: _showPlaybackSpeedDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C1E3A),
              Color(0xFF1A3A5F),
              Color(0xFF2E5F8A),
            ],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: currentSurah.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.2),
            height: 30,
          ),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1A3A5F).withOpacity(0.7),
                        Color(0xFF2E5F8A).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
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
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (currentSurah[index]["audio"]!.isNotEmpty)
                        IconButton(
                          icon: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: isPlaying && currentPlayingAyah == index
                                ? Icon(
                              Icons.pause_circle_filled,
                              key: ValueKey('pause'),
                              color: Colors.amber,
                              size: 32,
                            )
                                : Icon(
                              Icons.play_circle_fill,
                              key: ValueKey('play'),
                              color: Colors.amber,
                              size: 32,
                            ),
                          ),
                          onPressed: () => playAyah(index),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1A3A5F).withOpacity(0.7),
                        Color(0xFF2E5F8A).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    currentSurah[index]["arabic"]!,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Scheherazade',
                      height: 1.8,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1A3A5F).withOpacity(0.7),
                        Color(0xFF2E5F8A).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                        //jdfwjb
                      ),
                    ],
                  ),
                  child: Text(
                    currentSurah[index]["translation"] ?? "Translation not available",
                    style: TextStyle(
                      fontSize: 18,
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
    );
  }
}