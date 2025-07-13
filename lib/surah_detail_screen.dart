import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

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
List<Map<String, String>> currentSurah = [];
String _searchText = '';

@override
void initState() {
super.initState();
fetchSurah(widget.surahIndex + 1);
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
"audio": arabicAyahs[i]['audio']
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

Future<void> playAyah(int index) async {
if (currentPlayingAyah == index && isPlaying) {
await audioPlayer.stop();
setState(() {
isPlaying = false;
currentPlayingAyah = -1;
});
return;
}

final ayahData = currentSurah[index];
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
final filteredSurah = currentSurah.where((ayah) =>
ayah['arabic']!.contains(_searchText) ||
ayah['translation']!.toLowerCase().contains(_searchText.toLowerCase()));

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
body: currentSurah.isEmpty
? Center(child: CircularProgressIndicator(color: Colors.amber))
    : Column(
children: [
Padding(
padding: const EdgeInsets.all(12.0),
child: TextField(
decoration: InputDecoration(
hintText: 'Search translation...',
hintStyle: TextStyle(color: Colors.white60),
filled: true,
fillColor: Colors.white12,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
prefixIcon: Icon(Icons.search, color: Colors.white70),
),
style: TextStyle(color: Colors.white),
onChanged: (value) {
setState(() {
_searchText = value;
});
},
),
),
Expanded(
child: ListView.separated(
padding: EdgeInsets.all(16),
itemCount: filteredSurah.length,
separatorBuilder: (context, index) => Divider(
color: Colors.white.withOpacity(0.2),
height: 30,
),
itemBuilder: (context, index) {
final ayah = filteredSurah.elementAt(index);
return AnimatedContainer(
duration: Duration(milliseconds: 400),
curve: Curves.easeInOut,
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Container(
padding: EdgeInsets.symmetric(
horizontal: 12, vertical: 8),
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
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Container(
width: 30,
height: 30,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
Color(0xFFF9D423),
Color(0xFFFF4E50)
],
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
if (ayah["audio"]!.isNotEmpty)
IconButton(
icon: AnimatedSwitcher(
duration: Duration(milliseconds: 300),
child: isPlaying &&
currentPlayingAyah == index
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
ayah["arabic"]!,
style: TextStyle(
fontSize:
MediaQuery.of(context).size.width * 0.06,
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
),
],
),
child: Text(
ayah["translation"] ??
"Translation not available",
style: TextStyle(
fontSize: MediaQuery.of(context).size.width *
0.045,
color: Colors.white.withOpacity(0.9),
fontFamily: 'Poppins',
height: 1.5,
),
),
),
],
),
);
},
),
),
],
),
);
}
}
