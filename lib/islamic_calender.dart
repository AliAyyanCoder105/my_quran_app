import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'list_islamic_occasion.dart'; // Import the events data

class IslamicCalendarScreen extends StatefulWidget {
  @override
  _IslamicCalendarScreenState createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  late DateTime _displayedGregorianDate;
  late HijriCalendar _displayedHijriDate;

  @override
  void initState() {
    super.initState();
    _displayedGregorianDate = DateTime.now();
    _displayedHijriDate = HijriCalendar.fromDate(_displayedGregorianDate);
    HijriCalendar.setLocal('en');
  }

  void _changeMonth(int direction) {
    setState(() {
      _displayedGregorianDate = DateTime(_displayedGregorianDate.year, _displayedGregorianDate.month + direction, 1);
      _displayedHijriDate = HijriCalendar.fromDate(_displayedGregorianDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Islamic Calendar'),
        backgroundColor: Color(0xFF1A3A5F),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1E3A), Color(0xFF1A3A5F)],
          ),
        ),
        // ** THE ULTIMATE FIX: WRAP EVERYTHING IN A SINGLECHILDSCROLLVIEW **
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 600;

              if (isWideScreen) {
                return _buildWideLayout(constraints);
              } else {
                return _buildNarrowLayout(constraints);
              }
            },
          ),
        ),
      ),
    );
  }

  // Layout for standard portrait/phone screens
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    return Column(
      children: [
        _buildMonthHeader(constraints),
        _buildDaysOfWeekHeader(7),
        _buildCalendarGrid(constraints, 7),
        _buildEventsListHeader(constraints),
        _buildEventsForMonth(isScrollable: false), // The parent scrolls now
      ],
    );
  }

  // Layout for wide screens (tablets/landscape)
  Widget _buildWideLayout(BoxConstraints constraints) {
    return IntrinsicHeight( // Helps columns maintain same height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Calendar
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Take minimum required height
              children: [
                _buildMonthHeader(constraints),
                _buildDaysOfWeekHeader(7),
                _buildCalendarGrid(constraints, 7),
              ],
            ),
          ),
          VerticalDivider(color: Colors.white.withOpacity(0.2), width: 1),
          // Right Column: Events
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildEventsListHeader(constraints, isWide: true),
                Expanded(child: _buildEventsForMonth(isScrollable: true)), // This list can scroll independently
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BoxConstraints constraints) {
    double fontSize = constraints.maxWidth < 400 ? 20 : 24;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: constraints.maxWidth * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30),
            onPressed: () => _changeMonth(-1),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              key: ValueKey(_displayedHijriDate.hMonth),
              children: [
                Text(
                  _displayedHijriDate.toFormat("MMMM yyyy"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _displayedHijriDate.toFormat("gMMMM gyyyy"),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: fontSize * 0.6,
                  ),
                )
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.white, size: 30),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeekHeader(int crossAxisCount) {
    final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              days[index],
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarGrid(BoxConstraints constraints, int crossAxisCount) {
    double aspectRatio = constraints.maxWidth / constraints.maxHeight;
    double childAspectRatio = (crossAxisCount == 7)
        ? (aspectRatio > 0.6 ? 1.2 : 1.0)
        : 1.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(_displayedHijriDate.hMonth),
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _getDaysInMonthGrid().length,
          itemBuilder: (context, index) {
            final day = _getDaysInMonthGrid()[index];
            if (day == null) {
              return Container(); // Empty cell
            }

            final hijriDay = HijriCalendar.fromDate(day);
            final isToday = _isSameDay(day, DateTime.now());
            final event = _getEventForDay(hijriDay.hDay, hijriDay.hMonth);

            return Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isToday ? Border.all(color: Colors.amber, width: 2) : null,
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '${hijriDay.hDay}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (event != null)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: Colors.amber[300],
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 4)]
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventsListHeader(BoxConstraints constraints, {bool isWide = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, isWide ? 30 : 16, 20, 8),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber[300], size: 20),
          SizedBox(width: 10),
          Text(
            "Events This Month",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsForMonth({required bool isScrollable}) {
    final currentHijriMonth = _displayedHijriDate.hMonth;
    final events = islamicEvents.where((e) => e['month'] == currentHijriMonth).toList()
      ..sort((a, b) => a['day'].compareTo(b['day']));

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            "No special events this month.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: !isScrollable,
      physics: isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          color: Color(0xFF1A3A5F).withOpacity(0.7),
          margin: EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9D423), Color(0xFFFF4E50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${event['day']}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            title: Text(
              event['name'],
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${_getOrdinal(event['day'])} ${_displayedHijriDate.toFormat("MMMM")}',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    );
  }

  // --- Helper Functions ---
  List<DateTime?> _getDaysInMonthGrid() {
    final year = _displayedGregorianDate.year;
    final month = _displayedGregorianDate.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7

    List<DateTime?> days = [];

    for (int i = 0; i < firstWeekday - 1; i++) {
      days.add(null);
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(year, month, i));
    }

    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, dynamic>? _getEventForDay(int day, int month) {
    try {
      return islamicEvents.firstWhere((e) => e['day'] == day && e['month'] == month);
    } catch (e) {
      return null;
    }
  }

  String _getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1: return '${number}st';
      case 2: return '${number}nd';
      case 3: return '${number}rd';
      default: return '${number}th';
    }
  }
}