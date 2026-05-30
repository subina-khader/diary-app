import 'package:flutter/material.dart';
class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.pink.shade50,

        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child:  Text(
          "Mood Tracker",
          style: TextStyle(
            fontSize: 26,
            fontFamily: "Caveat",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
        ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child:Text(
                "Your Mood Distribution",
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: "Caveat",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(15),

              ),
              child: Text(
                "Recent Moods",
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: "Caveat",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(15),

              ),
            ),
          ],
        ),
      ),

    );
  }

}
