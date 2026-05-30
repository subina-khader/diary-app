import 'package:diary/models/diary_model.dart';
import 'package:diary/models/diarywith_count.dart';
import 'package:diary/screens/password_type_screen.dart';
import 'package:diary/screens/view_diary.dart';
import 'package:diary/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:diary/screens/create_diary_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/diaryprovider.dart';
import '../providers/selectdiary_provider.dart';
import 'mood_tracker.dart';

class HomeScreen extends ConsumerStatefulWidget {
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // List<DiaryModel> diaries = [];
  // List<int> count=[];
  List<DiarywithCount> diarys = [];
  int isSelected = -1;

  @override
  void initState() {
    super.initState();
    loadDiaries();
  }

  void loadDiaries() async {
    final data = await DatabaseHelper.instance.getDiary();
    diarys.clear();
    for (DiaryModel n in data) {
      List entries = await DatabaseHelper.instance.getAllEntriesByDiaryId(
        n.id!,
      );
      diarys.add(DiarywithCount(diary: n, count: entries.length));
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeNotifier = ref.read(diaryProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink.shade50,

        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(-33, 0),
                    child: Text(
                      "My Diaries",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: "Caveat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "Your personal collection",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14)
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MoodTracker()));
                    },
                    child: Icon(Icons.favorite_border,color: Colors.grey.shade600,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
        child: ListView.builder(
          itemCount: diarys.length,
          itemBuilder: (context, index) {
            return DiaryCard(
              diary: diarys[index].diary,
              count: diarys[index].count,
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDiary()),
          );
          loadDiaries();
        },
        child: Icon(Icons.add, size: 37),
      ),
    );
  }
}

class DiaryCard extends ConsumerWidget {
  final DiaryModel diary;
  final int count;
  DiaryCard({super.key, required this.diary, required this.count});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final selectedDiary = ref.read(SelectedDiaryProvider.notifier);

    return InkWell(

      onTap: () {
        selectedDiary.selectDiary(diary);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>diary.isPrivate?PasswordTypeScreen():ViewDiary()),
        );
      },

      child: Card(
        color: Color(diary.themeValue),
        elevation: 2,
        shadowColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white38,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      diary.categoryIconPath,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              // Spacer(),
              // Align(alignment: Alignment.center, child: Icon(Icons.kayaking)),
              Align(
                alignment: Alignment.center,
                child: Text(
                  diary.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Caveat",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "$count entries",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  diary.isPrivate
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white38,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(Icons.lock, size: 20),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
