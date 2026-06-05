import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/models/template_model.dart';
import 'package:diary/screens/template_screen.dart';
import 'package:diary/screens/view_diary.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/emojis_model.dart';
import '../../providers/selectdiary_provider.dart';
import '../../services/database_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
class EditDiaryentry extends ConsumerStatefulWidget {
  const EditDiaryentry({super.key});

  @override
  ConsumerState<EditDiaryentry> createState() => _EditDiaryentryState();
}

class _EditDiaryentryState extends ConsumerState<EditDiaryentry> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  DateTime selectedDate = DateTime.now();
  bool showFonts = false;
  bool showMoods = false;
  bool showStickers = false;
  bool showTemplates = false;
  String selectedFont = "Caveat";
  String selectedMoods = "Happy";
  Templates selectedTemplates = Templates.plain;


  int count = 1;
  List<String> fonts = [
    "Caveat",
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
    "ArchitectsDaughter",
  ];
  List<EmojiModel> moods = [
    EmojiModel(emoji: "😊", label: "Happy"),
    EmojiModel(emoji: "😔", label: "Sad"),
    EmojiModel(emoji: "🤩", label: "Excited"),
    EmojiModel(emoji: "😌", label: "Peaceful"),
    EmojiModel(emoji: "🤔", label: "Thoughtful"),
    EmojiModel(emoji: "🥰", label: "Loved"),
    EmojiModel(emoji: "😴", label: "Tired"),
    EmojiModel(emoji: "😎", label: "Cool"),
    EmojiModel(emoji: "🙏", label: "Blessed"),
  ];
  List<TemplateModel> templates = [
    TemplateModel(maxImage: 0, templateType: Templates.plain),
    TemplateModel(maxImage: 3, templateType: Templates.topImage),
    TemplateModel(maxImage: 6, templateType: Templates.doubleTopImage),
    TemplateModel(maxImage: 3, templateType: Templates.bottomImage),
    TemplateModel(maxImage: 6, templateType: Templates.doubleBottomImage),
    TemplateModel(maxImage: 5, templateType: Templates.leftImage),
    TemplateModel(maxImage: 5, templateType: Templates.rightImage),
    TemplateModel(maxImage: 12, templateType: Templates.images),
  ];
  List<File?> getImageOfTemplates(Templates templates){
    switch(templates){

      case Templates.topImage:
        return topImages;

      case Templates.doubleTopImage:
        return doubleTopImages;
      case Templates.bottomImage:
        return bottomImages;
      case Templates.doubleBottomImage:
        return doubleBottomImages;
      case Templates.leftImage:
        return leftImages;
      case Templates.rightImage:
        return rightImages;
      case Templates.images:
        return images;
      default:
        return [];


    }
  }
  ImagePicker picker = ImagePicker();
  List<File?> topImages = List.filled(3, null);
  List<File?> doubleTopImages = List.filled(6, null);
  List<File?> bottomImages = List.filled(3, null);
  List<File?> doubleBottomImages = List.filled(6, null);
  List<File?> leftImages = List.filled(5, null);
  List<File?> rightImages = List.filled(5, null);
  List<File?> images = List.filled(12, null);


  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Widget plainWidget() {
    return TextField(
      // keyboardType: TextInputType.multiline,
      // expands: true,
      maxLines: null,

      style: TextStyle(color: Colors.black, fontFamily: selectedFont),
      controller: _contentController,
      decoration: InputDecoration(
        hintText: "Write your thoughts here...",
        hintStyle: TextStyle(color: Colors.grey, fontFamily: selectedFont),
        border: InputBorder.none,
      ),
    );
  }

  Widget plainsWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: TextField(
          // keyboardType: TextInputType.multiline,
          // expands: true,
          maxLines: null,

          style: TextStyle(color: Colors.black, fontFamily: selectedFont),
          controller: _contentController,
          decoration: InputDecoration(
            hintText: "Write your thoughts here...",
            hintStyle: TextStyle(color: Colors.grey, fontFamily: selectedFont),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget topWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(count, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),

                    onTap: () async {
                      await pickImages(topImages, index);
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: topImages[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                topImages[index]!,

                                fit: BoxFit.cover,

                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),

            plainWidget(),
          ],
        ),
      ),
    );
  }

  Widget doubleTopWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),

                    onTap: () async {
                      await pickImages(doubleTopImages, index);
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: doubleTopImages[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                doubleTopImages[index]!,

                                fit: BoxFit.cover,

                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            plainWidget(),
          ],
        ),
      ),
    );
  }

  Widget bottomWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            plainWidget(),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(count, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),

                    onTap: () async {
                      await pickImages(bottomImages, index);
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: bottomImages[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                bottomImages[index]!,

                                fit: BoxFit.cover,

                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget doubleBottomWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            plainWidget(),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),

                    onTap: () async {
                      await pickImages(doubleBottomImages, index);
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: doubleBottomImages[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                doubleBottomImages[index]!,

                                fit: BoxFit.cover,

                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget leftWidget() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(count, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),

                    onTap: () async {
                      await pickImages(leftImages, index);
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: leftImages[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                leftImages[index]!,

                                fit: BoxFit.cover,

                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(width: 7),

          Expanded(child: plainWidget()),
        ],
      ),
    );
  }

  Widget rightWidget() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: plainWidget()),
          SizedBox(width: 7),
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(count, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),

                    onTap: () async {
                      await pickImages(rightImages, index);
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: rightImages[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(
                                rightImages[index]!,

                                fit: BoxFit.cover,

                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              textAlign: TextAlign.center,
              controller: _titleController,
              decoration: InputDecoration(
                isDense: true,

                contentPadding: EdgeInsets.zero,
                hintText: "Title",
                hintStyle: TextStyle(fontFamily: selectedFont, fontSize: 20),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: selectedFont,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            TextField(
              textAlign: TextAlign.center,

              controller: _subtitleController,
              decoration: InputDecoration(
                isDense: true,

                contentPadding: EdgeInsets.zero,
                hintText: "Subtitle",
                hintStyle: TextStyle(fontFamily: selectedFont, fontSize: 15),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: selectedFont,
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),

                  onTap: () async {
                    await pickImages(images, index);
                  },

                  child: Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: Colors.pink.shade100),
                    ),

                    child: images[index] == null
                        ? Icon(Icons.add, color: Colors.brown)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),

                            child: Image.file(
                              images[index]!,

                              fit: BoxFit.cover,

                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget pickTemplates(Templates temp) {
    switch (temp) {
      case Templates.topImage:
        return topWidget();

      case Templates.doubleTopImage:
        return doubleTopWidget();
      case Templates.bottomImage:
        return bottomWidget();

      case Templates.doubleBottomImage:
        return doubleBottomWidget();

      case Templates.leftImage:
        return leftWidget();
      case Templates.rightImage:
        return rightWidget();
      case Templates.images:
        return imageWidget();
      default:
        return plainsWidget();
    }
  }

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    loadIfContent(selectedDate);
  }

  Future<void> pickImages(List<File?> images, int index) async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final dir=await getApplicationDocumentsDirectory();
      final fileName=image.path.split('/').last;
      final savedImage=await File(image.path).
      copy("${dir.path}/$fileName",

      );
      setState(() {
        images[index] = savedImage;
      });
    }
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
                final imagePath = getImageOfTemplates(selectedTemplates).where((e)=>e!=null).map((e)=>e!.path).toList();
                final diaryEntry = DiaryEntryModel(
                  diaryId: selectDiary.id!,
                  content: _contentController.text,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                  font: selectedFont,
                  mood: selectedMoods,
                  templateIndex: selectedTemplates.index,
                  imagePaths: imagePath,
                  title: _titleController.text.trim(),
                  subtitle: _subtitleController.text.trim(),
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
                              fontFamily: selectedFont,
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
                      pickTemplates(selectedTemplates),
                    ],
                  ),
                ),
                // child: PageView.builder(itemCount:,itemBuilder: itemBuilder),
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TapOption(
                          icon: Icons.text_fields,
                          label: "Font",
                          onTap: () {
                            setState(() {
                              showFonts = !showFonts;
                              if (showFonts) {
                                showStickers = false;
                                showMoods = false;
                              }
                            });
                          },
                        ),

                        Spacer(),
                        TapOption(
                          icon: Icons.emoji_emotions_outlined,
                          label: "Mood",
                          onTap: () {
                            setState(() {
                              showMoods = !showMoods;
                              if (showMoods) {
                                showStickers = false;
                                showFonts = false;
                              }
                            });
                          },
                        ),

                        Spacer(),
                        TapOption(
                          icon: Icons.star_outline,
                          label: "Sticker",
                          onTap: () {
                            setState(() {
                              showStickers = !showStickers;
                              if (showStickers) {
                                showMoods = false;
                                showFonts = false;
                              }
                            });
                          },
                        ),

                        Spacer(),
                        TapOption(
                          icon: Icons.dashboard_customize_outlined,
                          label: "Template",
                          onTap: () async{
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TemplateScreen(),
                              ),
                            );
    if (result != null) {
                            setState(() {
                              selectedTemplates=templates[result["templateindex"]].templateType;
                              count=result["count"];
                            });}
                            // setState(() {
                            //   showTemplates = !showTemplates;
                            // });
                          },
                        ),
                      ],
                    ),

                    // if any onTap
                    if (showFonts) ...[
                      Divider(),
                      SizedBox(
                        height: 90,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 4,
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: fonts.length,
                          itemBuilder: (context, index) {
                            return OutlinedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: selectedFont == fonts[index]
                                        ? Colors.brown
                                        : Colors.pink.shade100,
                                  ),
                                ),
                                // maximumSize: MaterialStateProperty.all(Size(10,10)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  selectedFont == fonts[index]
                                      ? Colors.pink.shade50
                                      : Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedFont = fonts[index];
                                  showFonts = false;
                                });
                              },
                              child: Text(
                                fonts[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: fonts[index],
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    if (showMoods) ...[
                      Divider(),
                      SizedBox(
                        height: 90,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.6,
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: moods.length,
                          itemBuilder: (context, index) {
                            return OutlinedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: selectedMoods == moods[index].label
                                        ? Colors.brown
                                        : Colors.pink.shade100,
                                  ),
                                ),
                                // maximumSize: MaterialStateProperty.all(Size(10,10)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(19),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  selectedMoods == moods[index].label
                                      ? Colors.pink.shade50
                                      : Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMoods = moods[index].label;
                                  showMoods = false;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(moods[index].emoji),
                                  Text(
                                    moods[index].label,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    if (showStickers) ...[
                      Divider(),
                      SizedBox(
                        height: 130,
                        child: SingleChildScrollView(
                          child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              _contentController.text += emoji.emoji;
                              setState(() {
                                showStickers = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],

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

class TapOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  TapOption({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // focusColor: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(15),
        highlightColor: Colors.pink.shade50,
        overlayColor: MaterialStateProperty.all(Colors.pink.shade50),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: Colors.brown),
              Text(label, style: TextStyle(color: Colors.brown)),
            ],
          ),
        ),
      ),
    );
  }
}
