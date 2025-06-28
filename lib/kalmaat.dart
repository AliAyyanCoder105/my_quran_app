import 'package:flutter/material.dart';

class KalmaScreen extends StatefulWidget {
  @override
  _KalmaScreenState createState() => _KalmaScreenState();
}

class _KalmaScreenState extends State<KalmaScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> kalmaData = [
    {
      "title": "First Kalma (Tayyab)",
      "arabic": "لَا إِلَٰهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ",
      "transliteration": "La ilaha illallahu Muhammadur Rasulullah",
      "translation": "There is no god but Allah, Muhammad is the messenger of Allah."
    },
    {
      "title": "Second Kalma (Shahadat)",
      "arabic": "أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
      "transliteration": "Ashhadu an la ilaha illallahu wahdahu la sharika lahu wa ashhadu anna Muhammadan abduhu wa Rasuluhu.",
      "translation": "I bear witness that there is no god but Allah, the One, having no partner with Him, and I bear witness that Muhammad is His servant and His messenger."
    },
    {
      "title": "Third Kalma (Tamjeed)",
      "arabic": "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ",
      "transliteration": "Subhanallahi walhamdulillahi wa la ilaha illallahu wallahu akbar wala hawla wala quwwata illa billahil aliyyil azim.",
      "translation": "Glory be to Allah and all praise be to Allah, there is no god but Allah, and Allah is the Greatest. There is no might or power except from Allah, the Exalted, the Great."
    },
    {
      "title": "Fourth Kalma (Tauheed)",
      "arabic": "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ أَبَدًا أَبَدًا، ذُو الْجَلَالِ وَالْإِكْرَامِ، بِيَدِهِ الْخَيْرُ، وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
      "transliteration": "La ilaha illallahu wahdahu la sharika lahu, lahul mulku wa lahul hamdu, yuhyi wa yumitu wa huwa hayyun la yamutu abadan abada, dhul jalali wal ikram, biyadihil khair, wa huwa ala kulli shayin qadir.",
      "translation": "There is no god but Allah, Who is the only One, having no partner. For Him is the kingdom and for Him is the praise. He gives life and causes death. And He is Alive. He will not die, never, ever. Possessor of Majesty and Reverence. In His hand is all good, and He is over all things competent."
    },
    {
      "title": "Fifth Kalma (Astaghfar)",
      "arabic": "أَسْتَغْفِرُ اللَّهَ رَبِّي مِنْ كُلِّ ذَنْبٍ أَذْنَبْتُهُ عَمَدًا أَوْ خَطَأً سِرًّا أَوْ عَلَانِيَةً وَأَتُوبُ إِلَيْهِ مِنَ الذَّنْبِ الَّذِي أَعْلَمُ وَمِنَ الذَّنْبِ الَّذِي لَا أَعْلَمُ، إِنَّكَ أَنْتَ عَلَّامُ الْغُيُوبِ وَسَتَّارُ الْعُيُوبِ وَغَفَّارُ الذُّنُوبِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ",
      "transliteration": "Astaghfirullaha rabbi min kulli dhanbin adhanabtuhu amadan aw khata'an sirran aw alaniyatan wa atubu ilaihi minadh dhanbil ladhi a'lamu wa minadh dhanbil ladhi la a'lamu, innaka anta allamul ghuyubi wa sattarul uyubi wa ghaffarudh dhunubi, wala hawla wala quwwata illa billahil aliyyil azim.",
      "translation": "I seek forgiveness from Allah, my Lord, from every sin I committed knowingly or unknowingly, secretly or openly, and I turn towards Him from the sin that I know and from the sin that I do not know. Certainly You, You are the knower of the hidden things and the Concealer of the faults and the Forgiver of the sins. And there is no might and no power except from Allah, the Most High, the Most Great."
    },
    {
      "title": "Sixth Kalma (Radd-e-Kufr)",
      "arabic": "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ أَنْ أُشْرِكَ بِكَ شَيْئًا وَأَنَا أَعْلَمُ بِهِ وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ بِهِ، تُبْتُ عَنْهُ وَتَبَرَّأْتُ مِنَ الْكُفْرِ وَالشِّرْكِ وَالْكَذِبِ وَالْغِيبَةِ وَالْبِدْعَةِ وَالنَّمِيمَةِ وَالْفَوَاحِشِ وَالْبُهْتَانِ وَالْمَعَاصِي كُلِّهَا، وَأَسْلَمْتُ وَأَقُولُ لَا إِلَٰهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ",
      "transliteration": "Allahumma inni a'udhu bika min an ushrika bika shay'an wa ana a'lamu bihi wa astaghfiruka lima la a'lamu bihi, tubtu anhu wa tabarra'tu minal kufri wash shirki wal kadhibi wal gheebati wal bid'ati wan namimati wal fawahishi wal buhtani wal ma'asi kulliha, wa aslamtu wa aqulu la ilaha illallahu Muhammadur Rasulullah.",
      "translation": "O Allah! I seek refuge in You from that I should ascribe any partner with You knowingly. I seek Your forgiveness for the sin of which I have no knowledge. I repent from it. I have become disgusted with disbelief and polytheism, falsehood and back-biting, innovation and slander, lewdness and all sinful acts. I submit to Your will. I believe and I declare that there is no god but Allah and Muhammad is His Messenger."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Six Kalmas'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A3A5F), Color(0xFF2E5F8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: kalmaData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final kalma = kalmaData[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1A3A5F).withOpacity(0.7),
                            Color(0xFF2E5F8A).withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kalma['title']!,
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(color: Colors.amber.withOpacity(0.5), height: 30),
                          _buildSectionTitle("Arabic"),
                          Text(
                            kalma['arabic']!,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Scheherazade',
                              height: 1.8,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildSectionTitle("Transliteration"),
                          Text(
                            kalma['transliteration']!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildSectionTitle("Translation"),
                          Text(
                            kalma['translation']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildPageIndicator(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(kalmaData.length, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.amber : Colors.white.withOpacity(0.4),
          ),
        );
      }),
    );
  }
}