import 'package:flutter/material.dart';
import 'package:diary/widgets/button_adddiary.dart';
import 'package:diary/screens/adddiary/categorylistingpage.dart';
import 'package:diary/screens/adddiary/diarynamepage.dart';
import 'package:diary/screens/adddiary/privacypage.dart';
import 'package:diary/screens/adddiary/themepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDiary extends StatefulWidget {
  const CreateDiary({super.key});

  @override
  State<CreateDiary> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiary> {
  late final TextEditingController categoryController;
  late final TextEditingController descriptionController;
  late final PageController pgecontroller;
  int selectedIndex = 0;

  void initState() {
    super.initState();
    categoryController = TextEditingController();
    descriptionController = TextEditingController();
    pgecontroller = PageController();
  }

  void dispose() {
    // titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  highlightColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                Spacer(),
                Text(
                  "Create New Diary",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Caveat",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: index == selectedIndex ? 35 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? Colors.brown
                          : Colors.brown.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 25),

            // SizedBox(height: 30),
            Expanded(
              child: PageView(
                controller: pgecontroller,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: [
                  NamePage(controller: pgecontroller),
                  ThemePage(controller: pgecontroller),
                  CategoryPage(controller: pgecontroller),
                  PrivacyPage(controller: pgecontroller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
