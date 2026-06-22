import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import '../../providers/selectdiary_provider.dart';

class MoodTracker extends ConsumerStatefulWidget {
  const MoodTracker({super.key});

  @override
  ConsumerState<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends ConsumerState<MoodTracker> {
  List<Map<String, dynamic>> moods = [];
  Map<String, int> moodCounts = {};

  int maxCount = 1;

  String dominantMood = "";

  final Map<String, String> moodEmoji = {
    "Happy": "😊",
    "Sad": "😔",
    "Excited": "🤩",
    "Peaceful": "😌",
    "Thoughtful": "🤔",
    "Loved": "🥰",
    "Tired": "😴",
    "Cool": "😎",
    "Blessed": "🙏",
  };

  final Map<String, Color> moodColor = {
    "Happy": const Color(0xffD6B47A),
    "Sad": const Color(0xffAFAEC1),
    "Excited": const Color(0xffD59AA3),
    "Peaceful": const Color(0xffB6D6C4),
    "Thoughtful": const Color(0xffB48CB9),
    "Loved": const Color(0xffD9A3A8),
    "Tired": Colors.grey,
    "Cool": Colors.blue,
    "Blessed": Colors.amber,
  };
  String getInsight(String mood) {
    switch (mood) {
      case "Happy":
        return "You've been feeling mostly happy this week. Keep embracing the positive moments.";

      case "Peaceful":
        return "You've maintained a calm and peaceful mindset this week.";

      case "Excited":
        return "This week has been full of excitement and energy for you.";

      case "Thoughtful":
        return "You've spent time reflecting and thinking deeply this week.";

      case "Loved":
        return "Your week has been filled with warmth and meaningful connections.";

      case "Sad":
        return "This week seems emotionally challenging. Be gentle with yourself.";
      case "Cool":
        return "You've been feeling confident and relaxed this week. You're handling things with a calm and steady mindset.";

      case "Tired":
        return "This week seems to have taken a lot of energy. Remember to slow down, rest, and recharge when possible.";

      case "Blessed":
        return "You've been appreciating the positive moments in your life. Gratitude and meaningful experiences have shaped your week.";

      default:
        return "Keep tracking your moods to discover patterns.";
    }
  }

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {

    moods = await DatabaseHelper.instance.getAllMoods();

    moodCounts.clear();

    for (final mood in moods) {
      moodCounts[mood['mood']] = (moodCounts[mood['mood']] ?? 0) + 1;
    }
    if (moodCounts.isNotEmpty) {
      maxCount = moodCounts.values.reduce((a, b) => a > b ? a : b);
    }

    final now = DateTime.now();

    final weeklyMoods = moods.where((mood) {
      final date = DateTime.parse(mood['entryDate'] as String);

      return date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();

    Map<String, int> weeklyMoodCounts = {};

    for (final mood in weeklyMoods) {
      final moodName = mood['mood'] as String;

      weeklyMoodCounts[moodName] = (weeklyMoodCounts[moodName] ?? 0) + 1;
    }

    if (weeklyMoodCounts.isNotEmpty) {
      dominantMood = weeklyMoodCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    } else {
      dominantMood = "";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.pink.shade50,

        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Mood Tracker",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "Caveat",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: moods.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mood_outlined,
                      size: 80,
                      color: Colors.pink.shade200,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "No Mood Data Yet",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Start writing diary entries and selecting moods to unlock your mood insights and trends.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Mood Distribution",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 20),

                        ...moodCounts.entries.map(
                          (mood) => moodItem(
                            emoji: moodEmoji[mood.key] ?? "😊",
                            mood: mood.key,
                            value: mood.value,
                            progress: mood.value / maxCount,
                            color: moodColor[mood.key] ?? Colors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recent Moods",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 20),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: moods
                                .take(7)
                                .map(
                                  (mood) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: const Color(
                                            0xffF5EFE8,
                                          ),
                                          child: Text(
                                            moodEmoji[mood['mood']] ?? "😊",
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          DateFormat('dd').format(
                                            DateTime.parse(
                                              mood['entryDate'] as String,
                                            ),
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xffDCA6AD),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "✨ Weekly Insight",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          getInsight(dominantMood),
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      // body: Padding(
      //   padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
      //   child: Column(
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(15),
      //         ),
      //         child:Text(
      //           "Your Mood Distribution",
      //           style: TextStyle(
      //             fontSize: 26,
      //             fontFamily: "Caveat",
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       ),
      //
      //       Container(
      //         decoration: BoxDecoration(
      //             color: Colors.white,
      //           borderRadius: BorderRadius.circular(15),
      //
      //         ),
      //         child: Text(
      //           "Recent Moods",
      //           style: TextStyle(
      //             fontSize: 26,
      //             fontFamily: "Caveat",
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       ),
      //       Container(
      //         decoration: BoxDecoration(
      //             color: Colors.white,
      //           borderRadius: BorderRadius.circular(15),
      //
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

Widget moodItem({
  required String emoji,
  required String mood,
  required int value,
  required double progress,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),

            Expanded(child: Text(mood)),

            Text(value.toString()),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    ),
  );
}
