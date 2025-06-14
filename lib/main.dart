import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'ElHarrak',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Make AppBar transparent
          elevation: 0, // Remove AppBar shadow
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'ElHarrak',
          ),
          centerTitle: true, // Center the app bar title
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent, // Make BottomNavigationBar transparent
          selectedItemColor: Colors.white, // Change selected color
          unselectedItemColor: Colors.grey[300],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'ElHarrak'),
        ),
      ),
      home: Scaffold( // Wrap with Scaffold to add background gradient
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2E7D32), // Dark Green
                Color(0xFF4CAF50), // Green
                Color(0xFF81C784), // Light Green
              ],
            ),
          ),
          child: QuranApp(), // Place the QuranApp widget inside
        ),
      ),
    );
  }
}

class QuranApp extends StatefulWidget {
  @override
  _QuranAppState createState() => _QuranAppState();
}

class _QuranAppState extends State<QuranApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
      appBar: AppBar(
        title: Text('Quran App'),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Surah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Namaz',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  static List<Widget> _widgetOptions = <Widget>[
    SurahList(),
    NamazTime(),
  ];
}

class SurahList extends StatefulWidget {
  @override
  _SurahListState createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<String> surahNames = [
    "Al-Fatiha", "Al-Baqarah", "Aal-e-Imran", "An-Nisa", "Al-Ma'idah",
    "Al-An'am", "Al-A'raf", "Al-Anfal", "At-Tawbah", "Yunus",
    "Hud", "Yusuf", "Ar-Ra'd", "Ibrahim", "Al-Hijr", "An-Nahl", "Al-Isra", "Al-Kahf", "Maryam", "Ta-Ha",
    "Al-Anbiya", "Al-Hajj", "Al-Mu'minun", "An-Nur", "Al-Furqan", "Ash-Shu'ara", "An-Naml", "Al-Qasas", "Al-Ankabut", "Ar-Rum",
    "Luqman", "As-Sajdah", "Al-Ahzab", "Saba", "Fatir", "Ya-Sin", "As-Saffat", "Sad", "Az-Zumar", "Ghafir",
    "Fussilat", "Ash-Shura", "Az-Zukhruf", "Ad-Dukhan", "Al-Jathiyah", "Al-Ahqaf", "Muhammad", "Al-Fath", "Al-Hujurat", "Qaf",
    "Adh-Dhariyat", "At-Tur", "An-Najm", "Al-Qamar", "Ar-Rahman", "Al-Waqi'ah", "Al-Hadid", "Al-Mujadilah", "Al-Hashr", "Al-Mumtahanah",
    "As-Saff", "Al-Jumu'ah", "Al-Munafiqun", "At-Taghabun", "At-Talaq", "At-Tahrim", "Al-Mulk", "Al-Qalam", "Al-Haqqah", "Al-Ma'arij",
    "Nuh", "Al-Jinn", "Al-Muzzammil", "Al-Muddaththir", "Al-Qiyamah", "Al-Insan", "Al-Mursalat", "An-Naba", "An-Nazi'at", "Abasa",
    "At-Takwir", "Al-Infitar", "Al-Mutaffifin", "Al-Inshiqaq", "Al-Buruj", "At-Tariq", "Al-A'la", "Al-Ghashiyah", "Al-Fajr", "Al-Balad",
    "Ash-Shams", "Al-Layl", "Ad-Duha", "Ash-Sharh", "At-Tin", "Al-Alaq", "Al-Qadr", "Al-Bayyinah", "Az-Zalzalah", "Al-Adiyat",
    "Al-Qari'ah", "At-Takathur", "Al-Asr", "Al-Humazah", "Al-Fil", "Quraysh", "Al-Ma'un", "Al-Kawthar", "Al-Kafirun", "An-Nasr",
    "Al-Masad", "Al-Ikhlas", "Al-Falaq", "An-Nas"
  ];

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: surahNames.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Card(
              elevation: 3,
              color: Colors.white.withOpacity(0.8), // Semi-transparent white card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  surahNames[index],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'ElHarrak', color: Colors.green[900]), // Dark Green text
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.green[300],
                  radius: 25,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'ElHarrak'),
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => SurahDetailScreen(surahName: surahNames[index], surahIndex: index),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


class SurahDetailScreen extends StatelessWidget {
  final String surahName;
  final int surahIndex;

  SurahDetailScreen({required this.surahName, required this.surahIndex});

  // Dummy Quran data (replace with actual data)
  final List<List<Map<String, String>>> quranData = [
    [ // Al-Fatiha
      {"arabic": "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "translation": "Shuru Allah ke naam se jo bada meherban nihayat reham wala hai."},
      {"arabic": "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ", "translation": "Sab tareef Allah ke liye hai jo sare jahan ka palanhar hai."},
      {"arabic": "ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "translation": "Bada meherban nihayat reham wala."},
      {"arabic": "مَٰلِكِ يَوْمِ ٱلدِّينِ", "translation": "Insaaf ke din ka malik."},
      {"arabic": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", "translation": "Hum teri hi ibadat karte hain aur tujh hi se madad mangte hain."},
      {"arabic": "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ", "translation": "Humko seedhe raaste par chala."},
      {"arabic": "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ", "translation": "Un logon ka raasta jin par tune inaam kiya, na unka jin par gazab hua, aur na gumrahon ka."},
    ],
    [ // Al-Baqarah (Partial)
      {"arabic": "الم", "translation": "Alif-Laam-Meem."},
      {"arabic": "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ", "translation": "Yeh woh kitab hai jis mein koi shaq nahi, hidayat hai parhezgaron ke liye."},
    ],
    [ // Aal-e-Imran (Partial)
      {"arabic": "الٓمٓ", "translation": "Alif-Laam-Meem."},
      {"arabic": "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ", "translation": "Allah woh hai jis ke siwa koi maabood nahi, woh zinda aur qayem rehne wala hai."},
    ],
    [ // An-Nisa (Partial)
      {"arabic": "يَٰٓأَيُّهَا ٱلنَّاسُ ٱتَّقُوا۟ رَبَّكُمُ ٱلَّذِى خَلَقَكُم مِّن نَّفْسٍ وَٰحِدَةٍ وَخَلَقَ مِنْهَا زَوْجَهَا وَبَثَّ مِنْهُمَا رِجَالًا كَثِيرًا وَنِسَآءً ۚ وَٱتَّقُوا۟ ٱللَّهَ ٱلَّذِى تَسَآءَلُونَ بِهِۦ وَٱلْأَرْحَامَ ۚ إِنَّ ٱللَّهَ كَانَ عَلَيْكُمْ رَقِيبًا", "translation": "Aye logon! Apne uss rab se daro jis ne tumhe ek jaan se paida kiya aur usi se uski jodi banai aur un dono se bahut se mard aur auratein phaila diye aur uss Allah se daro jis ke naam par tum ek dusre se sawal karte ho aur rishton ka bhi khayal rakho, be shak Allah tum par nigehban hai."},
    ],
    [ // Al-Ma'idah (Partial)
      {"arabic": "يَٰٓأَيُّهَا ٱلَّذِينَ ءَامَنُوٓا۟ أَوْفُوا۟ بِٱلْعُقُودِ ۚ أُحِلَّتْ لَكُم بَهِيمَةُ ٱلْأَنْعَٰمِ إِلَّا مَا يُتْلَىٰ عَلَيْكُمْ غَيْرَ مُحِلِّى ٱلصَّيْدِ وَأَنتُمْ حُرُمٌ ۗ إِنَّ ٱللَّهَ يَحْكُمُ مَا يُرِيدُ", "translation": "Aye woh logon jo iman laye ho! Aqeedon ko poora karo, tumhare liye chaupaye janwar halal kiye gaye hain siwaye unke jo tumhe bataye jayenge, magar ehram ki halat mein shikar ko halal na samjho, be shak Allah jo chahta hai hukm karta hai."},
    ],
    // Add more Surah data here.  The List<Map<String, String>> corresponds to each Surah.
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentSurah = [];
    if (surahIndex < quranData.length) {
      currentSurah = quranData[surahIndex];
    } else {
      currentSurah = [
        {"arabic": "لا توجد بيانات", "translation": "Data Available Nahi Hai"}
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName, style: TextStyle(fontFamily: 'ElHarrak')),
        backgroundColor: Colors.green[800],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: currentSurah.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey[400]),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentSurah[index]["arabic"]!,
                    style: TextStyle(fontSize: 26, fontFamily: 'ElHarrak', color: Colors.green[900]),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentSurah[index]["translation"]!,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700], fontFamily: 'ElHarrak'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class NamazTime extends StatefulWidget {
  @override
  _NamazTimeState createState() => _NamazTimeState();
}

class _NamazTimeState extends State<NamazTime> {
  String fajrTime = 'Loading...';
  String dhuhrTime = 'Loading...';
  String asrTime = 'Loading...';
  String maghribTime = 'Loading...';
  String ishaTime = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getNamazTimes();
  }

  Future<void> _getNamazTimes() async {
    try {
      // Check if location permission is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permissions are denied. Please enable them in settings.'),
            ),
          );
          return; // Exit the function
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final latitude = position.latitude;
      final longitude = position.longitude;

      final now = DateTime.now();
      final year = now.year;
      final month = now.month;

      final url =
          'http://api.aladhan.com/v1/calendar/$year/$month?latitude=$latitude&longitude=$longitude&method=2';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final timings = jsonResponse['data'][now.day - 1]['timings'];

        setState(() {
          fajrTime = timings['Fajr'];
          dhuhrTime = timings['Dhuhr'];
          asrTime = timings['Asr'];
          maghribTime = timings['Maghrib'];
          ishaTime = timings['Isha'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load namaz times. Please check your internet connection and location settings.'),
          ),
        );
      }
    } catch (e) {
      print('Error getting location or namaz times: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildNamazTimeRow('Fajr', fajrTime),
            _buildNamazTimeRow('Dhuhr', dhuhrTime),
            _buildNamazTimeRow('Asr', asrTime),
            _buildNamazTimeRow('Maghrib', maghribTime),
            _buildNamazTimeRow('Isha', ishaTime),
          ],
        ),
      ),
    );
  }

  Widget _buildNamazTimeRow(String namazName, String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Use semi-transparent white
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            namazName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'ElHarrak', color: Colors.green[900]),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 20, fontFamily: 'ElHarrak', color: Colors.green[900]),
          ),
        ],
      ),
    );
  }
}