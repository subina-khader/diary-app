import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/screens/view_diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/selectdiary_provider.dart';
import '../../services/database_helper.dart';

class EditDiaryentry extends ConsumerStatefulWidget {
  const EditDiaryentry({super.key});

  @override
  ConsumerState<EditDiaryentry> createState() => _EditDiaryentryState();
}

class _EditDiaryentryState extends ConsumerState<EditDiaryentry> {
  late TextEditingController _contentController;
  DateTime selectedDate = DateTime.now();
  bool showFonts=false;
  List<String> fonts=["Caveat",
    "Kalam",
    "IndieFlower",
    "DancingScript",
    "Pacifico",
    "ShadowsIntoLight",
    "Handlee",
    "Satisfy",
    "AmaticSC",
    "PatrickHand",
    "GreatVibes",
    "Sacramento",
    "Courgette",
    "PermanentMarker",
    "ArchitectsDaughter",];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    loadIfContent(selectedDate);
  }

  Future<void> loadIfContent(DateTime selectedDate) async {
    final diary = ref.read(SelectedDiaryProvider);
    if (diary == null) return;
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    DiaryEntryModel? entry = await DatabaseHelper.instance
        .getEntryBySelectedDate(diary.id!, date);
    if (entry != null) {
      _contentController.text = entry.content;
    } else {
      _contentController.clear();
    }
  }

  Future<void> datePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
    await loadIfContent(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDiary = ref.read(SelectedDiaryProvider.notifier);
    final selectDiary = ref.watch(SelectedDiaryProvider);
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewDiary()));
              },
              child: Icon(Icons.close, color: Colors.brown),
            ),
            Text(
              "Edit Entry",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Caveat",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
              ),
              onPressed: () async {
                if (selectDiary == null) return;
                final diaryEntry = DiaryEntryModel(
                  diaryId: selectDiary.id!,
                  content: _contentController.text,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                );
                await DatabaseHelper.instance.insertDiaryEntry(diaryEntry);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(selectedDate),
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Caveat",
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              datePicker();
                            },
                            child: Icon(Icons.calendar_month, size: 19),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        // keyboardType: TextInputType.multiline,
                        // expands: true,
                        maxLines: null,

                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Caveat",
                        ),
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: "Write your thoughts here...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Caveat",
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                // child: PageView.builder(itemCount:,itemBuilder: itemBuilder),
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [

                        InkWell(
                          onTap: () {
                                 showFonts=!showFonts;
                          },
                          child: EditOptions(
                            data: Icons.text_fields,
                            label: "Font",
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {},
                          child: EditOptions(
                            data: Icons.emoji_emotions_outlined,
                            label: "Mood",
                          ),
                        ),
                        Spacer(),

                        InkWell(
                          onTap: () {},
                          child: EditOptions(
                            data: Icons.star_outline,
                            label: "Sticker",
                          ),
                        ),
                        Spacer(),

                        InkWell(
                          onTap: () {},
                          child: EditOptions(data: Icons.photo, label: "Photo"),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: EditOptions(
                            data: Icons.dashboard_customize_outlined,
                            label: "Template",
                          ),
                        ),
                        Spacer(),

                        InkWell(
                          onTap: () {},
                          child: EditOptions(
                            data: Icons.photo_library_outlined,
                            label: "Library",
                          ),
                        ),
                        Spacer(),

                        InkWell(
                          onTap: () {},
                          child: EditOptions(
                            data: Icons.crop_square,
                            label: "Frames",
                          ),
                        ),
                        Spacer(),

                        InkWell(
                          onTap: () {},
                          child: EditOptions(
                            data: Icons.auto_awesome,
                            label: "Decor",
                          ),
                        ),
                      ],
                    ),
                    // if any onTap
                    if(showFonts)...[
                    Divider(),
                    GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder:(context,index){
                      return  OutlinedButton(onPressed: (){}, child: Text(fonts[index]));

                    } ),
                    ]


                  ],
                ),
              ),
              // child: PageView.builder(itemCount:,itemBuilder: itemBuilder),
            ),
          ],
        ),
      ),
    );
  }
}

class EditOptions extends StatelessWidget {
  final IconData data;
  final String label;
  EditOptions({required this.data, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(data, color: Colors.brown),
        Text(label, style: TextStyle(color: Colors.brown)),
      ],
    );
  }
}
