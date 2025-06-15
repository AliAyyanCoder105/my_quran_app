import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SurahList extends StatefulWidget {
  @override
  _SurahListState createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: surahNames.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 10)),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white.withOpacity(0.15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => SurahDetailScreen(
                        surahName: surahNames[index],
                        surahIndex: index,
                      ),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          surahNames[index],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Scheherazade',
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.7),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

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

  final List<List<Map<String, String>>> quranData = [
  // Al-Fatiha (7 verses)
  [
  {
  "arabic": "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
  "translation": "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  {
  "arabic": "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ",
  "translation": "[All] praise is [due] to Allah, Lord of the worlds.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  {
  "arabic": "ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
  "translation": "The Entirely Merciful, the Especially Merciful.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  {
  "arabic": "مَٰلِكِ يَوْمِ ٱلدِّينِ",
  "translation": "Sovereign of the Day of Recompense.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  {
  "arabic": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
  "translation": "It is You we worship and You we ask for help.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  {
  "arabic": "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ",
  "translation": "Guide us to the straight path.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  {
  "arabic": "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ",
  "translation": "The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/001.mp3"
  },
  ],
  // Al-Baqarah (partial - first 5 verses)
  [
  {
  "arabic": "الم",
  "translation": "Alif, Lam, Meem.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/002.mp3"
  },
  {
  "arabic": "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ",
  "translation": "This is the Book about which there is no doubt, a guidance for those conscious of Allah.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/002.mp3"
  },
  {
  "arabic": "ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ",
  "translation": "Who believe in the unseen, establish prayer, and spend out of what We have provided for them.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/002.mp3"
  },
  {
  "arabic": "وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ أُنزِلَ إِلَيْكَ وَمَآ أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ",
  "translation": "And who believe in what has been revealed to you, [O Muhammad], and what was revealed before you, and of the Hereafter they are certain [in faith].",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/002.mp3"
  },
  {
  "arabic": "أُو۟لَٰٓئِكَ عَلَىٰ هُدًۭى مِّن رَّبِّهِمْ ۖ وَأُو۟لَٰٓئِكَ هُمُ ٱلْمُفْلِحُونَ",
  "translation": "It is they who are upon guidance from their Lord, and it is they who will be successful.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/002.mp3"
  },
  ],
  // Aal-e-Imran (partial - first 5 verses)
  [
  {
  "arabic": "الٓمٓ",
  "translation": "Alif, Lam, Meem.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/003.mp3"
  },
  {
  "arabic": "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ",
  "translation": "Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/003.mp3"
  },
  {
  "arabic": "نَزَّلَ عَلَيْكَ ٱلْكِتَٰبَ بِٱلْحَقِّ مُصَدِّقًۭا لِّمَا بَيْنَ يَدَيْهِ وَأَنزَلَ ٱلتَّوْرَىٰةَ وَٱلْإِنجِيلَ",
  "translation": "He has sent down upon you, [O Muhammad], the Book in truth, confirming what was before it. And He revealed the Torah and the Gospel.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/003.mp3"
  },
  {
  "arabic": "مِن قَبْلُ هُدًۭى لِّلنَّاسِ وَأَنزَلَ ٱلْفُرْقَانَ ۗ إِنَّ ٱلَّذِينَ كَفَرُوا۟ بِـَٔايَٰتِ ٱللَّهِ لَهُمْ عَذَابٌۭ شَدِيدٌۭ ۗ وَٱللَّهُ عَزِيزٌۭ ذُو ٱنتِقَامٍ",
  "translation": "Before, as guidance for the people. And He revealed the Qur'an. Indeed, those who disbelieve in the verses of Allah will have a severe punishment, and Allah is exalted in Might, the Owner of Retribution.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/003.mp3"
  },
  {
  "arabic": "إِنَّ ٱللَّهَ لَا يَخْفَىٰ عَلَيْهِ شَىْءٌۭ فِى ٱلْأَرْضِ وَلَا فِى ٱلسَّمَآءِ",
  "translation": "Indeed, from Allah nothing is hidden in the earth nor in the heaven.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/003.mp3"
  },
  ],
  // An-Nisa (partial - first 5 verses)
  [
  {
  "arabic": "يَٰٓأَيُّهَا ٱلنَّاسُ ٱتَّقُوا۟ رَبَّكُمُ ٱلَّذِى خَلَقَكُم مِّن نَّفْسٍۢ وَٰحِدَةٍۢ وَخَلَقَ مِنْهَا زَوْجَهَا وَبَثَّ مِنْهُمَا رِجَالًۭا كَثِيرًۭا وَنِسَآءًۭ ۚ وَٱتَّقُوا۟ ٱللَّهَ ٱلَّذِى تَسَآءَلُونَ بِهِۦ وَٱلْأَرْحَامَ ۚ إِنَّ ٱللَّهَ كَانَ عَلَيْكُمْ رَقِيبًۭا",
  "translation": "O mankind, fear your Lord, who created you from one soul and created from it its mate and dispersed from both of them many men and women. And fear Allah, through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/004.mp3"
  },
  {
  "arabic": "وَءَاتُوا۟ ٱلْيَتَٰمَىٰٓ أَمْوَٰلَهُمْ ۖ وَلَا تَتَبَدَّلُوا۟ ٱلْخَبِيثَ بِٱلطَّيِّبِ ۖ وَلَا تَأْكُلُوٓا۟ أَمْوَٰلَهُمْ إِلَىٰٓ أَمْوَٰلِكُمْ ۚ إِنَّهُۥ كَانَ حُوبًۭا كَبِيرًۭا",
  "translation": "And give the orphans their properties and do not substitute the defective [of your own] for the good [of theirs]. And do not consume their properties into your own. Indeed, that is ever a great sin.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/004.mp3"
  },
  {
  "arabic": "وَإِنْ خِفْتُمْ أَلَّا تُقْسِطُوا۟ فِى ٱلْيَتَٰمَىٰ فَٱنكِحُوا۟ مَا طَابَ لَكُم مِّنَ ٱلنِّسَآءِ مَثْنَىٰ وَثُلَٰثَ وَرُبَٰعَ ۖ فَإِنْ خِفْتُمْ أَلَّا تَعْدِلُوا۟ فَوَٰحِدَةً أَوْ مَا مَلَكَتْ أَيْمَٰنُكُمْ ۚ ذَٰلِكَ أَدْنَىٰٓ أَلَّا تَعُولُوا۟",
  "translation": "And if you fear that you will not deal justly with the orphan girls, then marry those that please you of [other] women, two or three or four. But if you fear that you will not be just, then [marry only] one or those your right hand possesses. That is more suitable that you may not incline [to injustice].",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/004.mp3"
  },
  {
  "arabic": "وَءَاتُوا۟ ٱلنِّسَآءَ صَدُقَٰتِهِنَّ نِحْلَةًۭ ۚ فَإِن طِبْنَ لَكُمْ عَن شَىْءٍۢ مِّنْهُ نَفْسًۭا فَكُلُوهُ هَنِيٓـًۭٔا مَّرِيٓـًۭٔا",
  "translation": "And give the women [upon marriage] their [bridal] gifts graciously. But if they give up willingly to you anything of it, then take it in satisfaction and ease.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/004.mp3"
  },
  {
  "arabic": "وَلَا تُؤْتُوا۟ ٱلسُّفَهَآءَ أَمْوَٰلَكُمُ ٱلَّتِى جَعَلَ ٱللَّهُ لَكُمْ قِيَٰمًۭا وَٱرْزُقُوهُمْ فِيهَا وَٱكْسُوهُمْ وَقُولُوا۟ لَهُمْ قَوْلًۭا مَّعْرُوفًۭا",
  "translation": "And do not give the weak-minded your property, which Allah has made a means of sustenance for you, but provide for them with it and clothe them and speak to them words of appropriate kindness.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/004.mp3"
  },
  ],
  // Al-Ma'idah (partial - first 5 verses)
  [
  {
  "arabic": "يَٰٓأَيُّهَا ٱلَّذِينَ ءَامَنُوٓا۟ أَوْفُوا۟ بِٱلْعُقُودِ ۚ أُحِلَّتْ لَكُم بَهِيمَةُ ٱلْأَنْعَٰمِ إِلَّا مَا يُتْلَىٰ عَلَيْكُمْ غَيْرَ مُحِلِّى ٱلصَّيْدِ وَأَنتُمْ حُرُمٌۭ ۗ إِنَّ ٱللَّهَ يَحْكُمُ مَا يُرِيدُ",
  "translation": "O you who have believed, fulfill [all] contracts. Lawful for you are the animals of grazing livestock except for that which is recited to you [in this Qur'an] - [being] unlawful [while] you are in the state of ihram. Indeed, Allah ordains what He intends.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/005.mp3"
  },
  {
  "arabic": "يَٰٓأَيُّهَا ٱلَّذِينَ ءَامَنُوا۟ لَا تُحِلُّوا۟ شَعَٰٓئِرَ ٱللَّهِ وَلَا ٱلشَّهْرَ ٱلْحَرَامَ وَلَا ٱلْهَدْىَ وَلَا ٱلْقَلَٰٓئِدَ وَلَآ ءََآمِّينَ ٱلْبَيْتَ ٱلْحَرَامَ يَبْتَغُونَ فَضْلًۭا مِّن رَّبِّهِمْ وَرِضْوَٰنًۭا ۚ وَإِذَا حَلَلْتُمْ فَٱصْطَادُوا۟ ۚ وَلَا يَجْرِمَنَّكُمْ شَنَـَٔانُ قَوْمٍ أَن صَدُّوكُمْ عَنِ ٱلْمَسْجِدِ ٱلْحَرَامِ أَن تَعْتَدُوا۟ ۘ وَتَعَاوَنُوا۟ عَلَى ٱلْبِرِّ وَٱلتَّقْوَىٰ ۖ وَلَا تَعَاوَنُوا۟ عَلَى ٱلْإِثْمِ وَٱلْعُدْوَٰنِ ۚ وَٱتَّقُوا۟ ٱللَّهَ ۖ إِنَّ ٱللَّهَ شَدِيدُ ٱلْعِقَابِ",
  "translation": "O you who have believed, do not violate the rites of Allah or [the sanctity of] the sacred month or [neglect the marking of] the sacrificial animals and garlanding [them] or [violate the safety of] those coming to the Sacred House seeking bounty from their Lord and [His] approval. But when you come out of ihram, then [you may] hunt. And do not let the hatred of a people for having obstructed you from al-Masjid al-Haram lead you to transgress. And cooperate in righteousness and piety, but do not cooperate in sin and aggression. And fear Allah; indeed, Allah is severe in penalty.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/005.mp3"
  },
  {
  "arabic": "حُرِّمَتْ عَلَيْكُمُ ٱلْمَيْتَةُ وَٱلدَّمُ وَلَحْمُ ٱلْخِنزِيرِ وَمَآ أُهِلَّ لِغَيْرِ ٱللَّهِ بِهِۦ وَٱلْمُنْخَنِقَةُ وَٱلْمَوْقُوذَةُ وَٱلْمُتَرَدِّيَةُ وَٱلنَّطِيحَةُ وَمَآ أَكَلَ ٱلسَّبُعُ إِلَّا مَا ذَكَّيْتُمْ وَمَا ذُبِحَ عَلَى ٱلنُّصُبِ وَأَن تَسْتَقْسِمُوا۟ بِٱلْأَزْلَٰمِ ۚ ذَٰلِكُمْ فِسْقٌۭ ۗ ٱلْيَوْمَ يَئِسَ ٱلَّذِينَ كَفَرُوا۟ مِن دِينِكُمْ فَلَا تَخْشَوْهُمْ وَٱخْشَوْنِ ۚ ٱلْيَوْمَ أَكْمَلْتُ لَكُمْ دِينَكُمْ وَأَتْمَمْتُ عَلَيْكُمْ نِعْمَتِى وَرَضِيتُ لَكُمُ ٱلْإِسْلَٰمَ دِينًۭا ۚ فَمَنِ ٱضْطُرَّ فِى مَخْمَصَةٍ غَيْرَ مُتَجَانِفٍۢ لِّإِثْمٍۢ ۙ فَإِنَّ ٱللَّهَ غَفُورٌۭ رَّحِيمٌۭ",
  "translation": "Prohibited to you are dead animals, blood, the flesh of swine, and that which has been dedicated to other than Allah, and [those animals] killed by strangling or by a violent blow or by a head-long fall or by the goring of horns, and those from which a wild animal has eaten, except what you [are able to] slaughter [before its death], and those which are sacrificed on stone altars, and [prohibited is] that you seek decision through divining arrows. That is grave disobedience. This day those who disbelieve have despaired of [defeating] your religion; so fear them not, but fear Me. This day I have perfected for you your religion and completed My favor upon you and have approved for you Islam as religion. But whoever is forced by severe hunger with no inclination to sin - then indeed, Allah is Forgiving and Merciful.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/005.mp3"
  },
  {
  "arabic": "يَسْـَٔلُونَكَ مَاذَآ أُحِلَّ لَهُمْ ۖ قُلْ أُحِلَّ لَكُمُ ٱلطَّيِّبَٰتُ ۙ وَمَا عَلَّمْتُم مِّنَ ٱلْجَوَارِحِ مُكَلِّبِينَ تُعَلِّمُونَهُنَّ مِمَّا عَلَّمَكُمُ ٱللَّهُ ۖ فَكُلُوا۟ مِمَّآ أَمْسَكْنَ عَلَيْكُمْ وَٱذْكُرُوا۟ ٱسْمَ ٱللَّهِ عَلَيْهِ ۖ وَٱتَّقُوا۟ ٱللَّهَ ۚ إِنَّ ٱللَّهَ سَرِيعُ ٱلْحِسَابِ",
  "translation": "They ask you, [O Muhammad], what has been made lawful for them. Say, "//Lawful for you are [all] good foods and [game caught by] what you have trained of hunting animals which you train as Allah has taught you. So eat of what they catch for you, and mention the name of Allah upon it, and fear Allah." Indeed, Allah is swift in account.",

  },
  {
  "arabic": "ٱلْيَوْمَ أُحِلَّ لَكُمُ ٱلطَّيِّبَٰتُ ۖ وَطَعَامُ ٱلَّذِينَ أُوتُوا۟ ٱلْكِتَٰبَ حِلٌّۭ لَّكُمْ وَطَعَامُكُمْ حِلٌّۭ لَّهُمْ ۖ وَٱلْمُحْصَنَٰتُ مِنَ ٱلْمُؤْمِنَٰتِ وَٱلْمُحْصَنَٰتُ مِنَ ٱلَّذِينَ أُوتُوا۟ ٱلْكِتَٰبَ مِن قَبْلِكُمْ إِذَآ ءَاتَيْتُمُوهُنَّ أُجُورَهُنَّ مُحْصِنِينَ غَيْرَ مُسَٰفِحِينَ وَلَا مُتَّخِذِىٓ أَخْدَانٍۢ ۗ وَمَن يَكْفُرْ بِٱلْإِيمَٰنِ فَقَدْ حَبِطَ عَمَلُهُۥ وَهُوَ فِى ٱلْءَاخِرَةِ مِنَ ٱلْخَٰسِرِينَ",
  "translation": "This day [all] good foods have been made lawful, and the food of those who were given the Scripture is lawful for you and your food is lawful for them. And [lawful inmarriage are] chaste women from among the believers and chaste women from among those who were given the Scripture before you, when you have given them their due compensation, desiring chastity, not unlawful sexual intercourse or taking [secret] lovers. And whoever denies the faith - his work has become worthless, and he, in the Hereafter, will be among the losers.",
  "audio": "https://download.quranicaudio.com/quran/mishary_rashid_alafasy/005.mp3"
  },
  ],
  // For other surahs (empty data)
  for (int i = 5; i < 114; i++)
  [
  {
  "arabic": "سورة ${i + 1}",
  "translation": "Coming soon...",
  "audio": ""
  }
  ],
  ];

  @override
  void dispose() {
  audioPlayer.dispose();
  super.dispose();
  }
  Future<void> playAyah(int index) async {
    if (currentPlayingAyah == index && isPlaying) {
      try {
        await audioPlayer.stop();
      } catch (e) {
        print("Error stopping audio: $e");
      }
      setState(() {
        isPlaying = false;
        currentPlayingAyah = -1;
      });
      return;
    }

    final ayahData = quranData[widget.surahIndex][index];
    if (ayahData["audio"] == null || ayahData["audio"]!.isEmpty) {
      setState(() {
        isPlaying = false;
        currentPlayingAyah = -1;
      });
      return;
    }

    try {
      setState(() {
        currentPlayingAyah = index;
        isPlaying = true;
      });

      await audioPlayer.play(UrlSource(ayahData["audio"]!));

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
          currentPlayingAyah = -1;
        });
      });

      // Removed error listener for now

    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        isPlaying = false;
        currentPlayingAyah = -1;
      });
    }
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
  backgroundColor: Color(0xFF0D47A1),
  appBar: AppBar(
  title: Text(widget.surahName, style: TextStyle(fontFamily: 'Scheherazade')),
  flexibleSpace: Container(
  decoration: BoxDecoration(
  gradient: LinearGradient(
  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
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
  colors: [
  Color(0xFF0D47A1),
  Color(0xFF1B5E20),
  Color(0xFF2E7D32),
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
  color: Colors.white.withOpacity(0.1),
  borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Container(
  width: 30,
  height: 30,
  decoration: BoxDecoration(
  color: Colors.amber.withOpacity(0.3),
  shape: BoxShape.circle,
  border: Border.all(
  color: Colors.amber,
  width: 1.5,
  ),
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
  icon: Icon(
  currentPlayingAyah == index && isPlaying
  ? Icons.pause_circle_filled
      : Icons.play_circle_fill,
  color: Colors.amber,
  size: 32,
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
  color: Colors.white.withOpacity(0.1),
  borderRadius: BorderRadius.circular(12),
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
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        currentSurah[index]["translation"] ?? "Translation not available", // Provide a default value
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