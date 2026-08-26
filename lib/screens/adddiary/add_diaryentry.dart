import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/models/template_model.dart';
import 'package:diary/screens/template_screen.dart';
import 'package:diary/screens/full_screen_image.dart';
import 'package:diary/screens/view_diary.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';
import '../../models/emojis_model.dart';
import '../../models/media_model.dart';
import '../../providers/selectdiary_provider.dart';
import '../../services/database_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/video_thumbnail.dart';
class AddDiaryentry extends ConsumerStatefulWidget {
  const AddDiaryentry({super.key});






  @override
  ConsumerState<AddDiaryentry> createState() => _AddDiaryentryState();
}

class _AddDiaryentryState extends ConsumerState<AddDiaryentry> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  DateTime selectedDate = DateTime.now();
  List<MediaFile>? loadedMedia;
  bool showFonts = false;
  bool showMoods = false;
  bool showStickers = false;
  bool showTemplates = false;
  String selectedFont = "Caveat";
  String selectedMoods = "Happy";
  Templates selectedTemplates = Templates.plain;
  bool hasEntry = false;
  int? selectedMediaIndex;
  String? selectedMediaGroup;
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
    TemplateModel(maxImage: 3, templateType: Templates.topMedia),
    TemplateModel(maxImage: 6, templateType: Templates.doubleTopMedia),
    TemplateModel(maxImage: 3, templateType: Templates.bottomMedia),
    TemplateModel(maxImage: 6, templateType: Templates.doubleBottomMedia),
    TemplateModel(maxImage: 5, templateType: Templates.leftMedia),
    TemplateModel(maxImage: 5, templateType: Templates.rightMedia),
    TemplateModel(maxImage: 12, templateType: Templates.medias),
  ];

  Future<void> pickMedia(List<MediaFile?> mediaList, int index) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Image"),
              onTap: () async {
                Navigator.pop(context);

                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (file != null) {
                  mediaList[index] = MediaFile(
                    path: file.path,
                    type: MediaType.image,
                  );

                  setState(() {});
                }
              },
            ),

            ListTile(
              leading: Icon(Icons.video_library),
              title: Text("Video"),
              onTap: () async {
                Navigator.pop(context);

                final file = await picker.pickVideo(
                  source: ImageSource.gallery,
                );

                if (file != null) {
                  mediaList[index] = MediaFile(
                    path: file.path,
                    type: MediaType.video,
                  );

                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<MediaFile?> getMediaOfTemplates(Templates templates) {
    switch (templates) {
      case Templates.topMedia:
        return topMedia;

      case Templates.doubleTopMedia:
        return doubleTopMedia;
      case Templates.bottomMedia:
        return bottomMedia;
      case Templates.doubleBottomMedia:
        return doubleBottomMedia;
      case Templates.leftMedia:
        return leftMedia;
      case Templates.rightMedia:
        return rightMedia;
      case Templates.medias:
        return medias;
      default:
        return [];
    }
  }

  ImagePicker picker = ImagePicker();
  List<MediaFile?> topMedia = List.filled(3, null);
  List<MediaFile?> doubleTopMedia = List.filled(6, null);
  List<MediaFile?> bottomMedia = List.filled(3, null);
  List<MediaFile?> doubleBottomMedia = List.filled(6, null);
  List<MediaFile?> leftMedia = List.filled(5, null);
  List<MediaFile?> rightMedia = List.filled(5, null);
  List<MediaFile?> medias = List.filled(12, null);
  List<DateTime> entryDates = [];
  String? selectedImageKey;
  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Widget buildMediaTile({
    required MediaFile media,
    required List<MediaFile?> mediaList,
    required int index,
  }) {
    bool isSelected =
        selectedMediaIndex == index &&
        selectedMediaGroup == mediaList.hashCode.toString();

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedMediaIndex = null;
            selectedMediaGroup = null;
          } else {
            selectedMediaIndex = index;
            selectedMediaGroup = mediaList.hashCode.toString();
          }
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          media.type == MediaType.image
              ? Image.file(File(media.path), fit: BoxFit.cover)
              // :
          : Stack(
            fit: StackFit.expand,
            children: [
              VideoThumbnailWidget(
                videoPath: media.path,
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),

          if (isSelected) Container(color: Colors.black.withOpacity(.45)),

          if (isSelected)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FullScreenImage(media: media,),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      await pickMedia(mediaList, index);
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  // IconButton(
                  //   onPressed: () async {
                  //     await pickMedia(
                  //       mediaList,
                  //       index,
                  //     );
                  //   },
                  //   icon: const Icon(
                  //     Icons.edit,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Widget buildMediaTile({
  //   required MediaFile media,
  //   required List<MediaFile?> mediaList,
  //   required int index,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: media.type == MediaType.image
  //         ? ClipRRect(
  //       borderRadius: BorderRadius.circular(12),
  //       child: Image.file(
  //         File(media.path),
  //         fit: BoxFit.cover,
  //       ),
  //     )
  //         : Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         Container(
  //           color: Colors.black12,
  //         ),
  //         const Center(
  //           child: Icon(
  //             Icons.play_circle_fill,
  //             size: 40,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Future<void> loadEntryDates() async {
    final diary = ref.read(SelectedDiaryProvider);
    if (diary == null) return;

    final entries = await DatabaseHelper.instance.getAllEntriesByDiaryId(
      diary.id!,
    );
    entryDates = entries.map((e) => DateTime.parse(e.date)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    loadIfContent(selectedDate);
    loadEntryDates();
  }
  // Widget buildMedia(MediaFile media) {
  //   if (media.type == MediaType.image) {
  //     return Image.file(
  //       File(media.path),
  //       fit: BoxFit.cover,
  //     );
  //   }
  //
  //   return Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       VideoThumbnailWidget(
  //         videoPath: media.path,
  //       ),
  //       Center(
  //         child: Icon(
  //           Icons.play_circle_fill,
  //           size: 40,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Future<DateTime?> datePicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            child: TableCalendar(
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool hasEntry = entryDates.any((e) => isSameDay(day, e));
                  if (hasEntry) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink.shade200,
                        ),
                        child: Center(
                          child: Text(
                            "${day.day}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              focusedDay: selectedDate,
              firstDay: DateTime(2000),
              lastDay: DateTime(2090),
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate, day);
              },
              headerStyle: HeaderStyle(formatButtonVisible: false),
              onDaySelected: (selectedDay, focusedDate) async {
                setState(() {
                  selectedDate = selectedDay;
                });
                await loadIfContent(selectedDay);

                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
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
                      if (topMedia[index] == null) {
                        await pickMedia(topMedia, index);
                      } else {
                        showMediaOptions(topMedia, index);
                      }
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: topMedia[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : buildMediaTile(
                              media: topMedia[index]!,
                              mediaList: topMedia,
                              index: index,
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
                      if (doubleTopMedia[index] == null) {
                        await pickMedia(doubleTopMedia, index);
                      } else {
                        showMediaOptions(doubleTopMedia, index);
                      }
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: doubleTopMedia[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : buildMediaTile(
                              media: doubleTopMedia[index]!,
                              mediaList: doubleTopMedia,
                              index: index,
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
                      if (bottomMedia[index] == null) {
                        await pickMedia(bottomMedia, index);
                      } else {
                        showMediaOptions(bottomMedia, index);
                      }
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: bottomMedia[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : buildMediaTile(
                              media: bottomMedia[index]!,
                              mediaList: bottomMedia,
                              index: index,
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
                      if (doubleBottomMedia[index] == null) {
                        await pickMedia(doubleBottomMedia, index);
                      } else {
                        showMediaOptions(doubleBottomMedia, index);
                      }
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: doubleBottomMedia[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : buildMediaTile(
                              media: doubleBottomMedia[index]!,
                              mediaList: doubleBottomMedia,
                              index: index,
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
                      if (leftMedia[index] == null) {
                        await pickMedia(leftMedia, index);
                      } else {
                        showMediaOptions(leftMedia, index);
                      }
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: leftMedia[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : buildMediaTile(
                              media: leftMedia[index]!,
                              mediaList: leftMedia,
                              index: index,
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
                      if (rightMedia[index] == null) {
                        await pickMedia(rightMedia, index);
                      } else {
                        showMediaOptions(rightMedia, index);
                      }
                    },

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.pink.shade100),
                      ),

                      child: rightMedia[index] == null
                          ? Icon(Icons.add, color: Colors.brown)
                          : buildMediaTile(
                              media: rightMedia[index]!,
                              mediaList: rightMedia,
                              index: index,
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
                    if (medias[index] == null) {
                      await pickMedia(medias, index);
                    } else {
                      showMediaOptions(medias, index);
                    }
                  },

                  child: Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: Colors.pink.shade100),
                    ),

                    child: medias[index] == null
                        ? Icon(Icons.add, color: Colors.brown)
                        : buildMediaTile(
                            media: medias[index]!,
                            mediaList: medias,
                            index: index,
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
      case Templates.topMedia:
        return topWidget();

      case Templates.doubleTopMedia:
        return doubleTopWidget();
      case Templates.bottomMedia:
        return bottomWidget();

      case Templates.doubleBottomMedia:
        return doubleBottomWidget();

      case Templates.leftMedia:
        return leftWidget();
      case Templates.rightMedia:
        return rightWidget();
      case Templates.medias:
        return imageWidget();
      default:
        return plainsWidget();
    }
  }

  // Future<void> pickImages(List<File?> images, int index) async {
  //   XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     final dir = await getApplicationDocumentsDirectory();
  //     final fileName = image.path.split('/').last;
  //     final savedImage = await File(image.path).copy("${dir.path}/$fileName");
  //     setState(() {
  //       images[index] = savedImage;
  //     });
  //   }
  // }

  Future<void> loadIfContent(DateTime selectedDate) async {
    final diary = ref.read(SelectedDiaryProvider);
    if (diary == null) return;
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    DiaryEntryModel? entry = await DatabaseHelper.instance
        .getEntryBySelectedDate(diary.id!, date);
    if (entry != null) {
      _contentController.text = entry.content;
      selectedTemplates = templates[entry.templateIndex].templateType;
      selectedMoods = entry.mood;
      selectedFont = entry.font;
      pickTemplates(selectedTemplates);
      if (selectedTemplates == Templates.medias) {
        _titleController.text = entry.title ?? "";
        _subtitleController.text = entry.subtitle ?? "";
      }
      final loadedMedia = entry.mediaFiles;
      if (loadedMedia != null) {
        count = loadedMedia.length;

        final templt = getMediaOfTemplates(selectedTemplates);
        for (int i = 0; i < loadedMedia.length; i++) {
          templt[i] = loadedMedia[i];
        }
      }
      setState(() {
        hasEntry = true;
      });
    } else {
      _contentController.clear();
      _titleController.clear();
      _subtitleController.clear();
      selectedTemplates = Templates.plain;
      selectedFont = "Caveat";
      selectedMoods = "Happy";
      count = 1;
      topMedia = List.filled(3, null);
      doubleTopMedia = List.filled(6, null);
      bottomMedia = List.filled(3, null);
      doubleBottomMedia = List.filled(6, null);
      leftMedia = List.filled(5, null);
      rightMedia = List.filled(5, null);
      medias = List.filled(12, null);

      setState(() {
        hasEntry = false;
      });
    }
  }

  Future<void> changeTemplates(newTemplates, newCount) async {
    List<MediaFile?> oldImages = List.from(
      getMediaOfTemplates(selectedTemplates),
    );
    int oldImageLength = oldImages.where((e) => e != null).length;

    if (oldImageLength <= newCount) {
      selectedTemplates = newTemplates;
      count = newCount;
      List<MediaFile?> newImages = getMediaOfTemplates(selectedTemplates);

      for (int i = 0; i < oldImageLength; i++) {
        newImages[i] = oldImages[i];
      }
      setState(() {});
    } else {
      final remainingImages = await showDialog(
        context: context,
        builder: (context) {
          final dialogImages = oldImages.where((e) => e != null).toList();
          return StatefulBuilder(
            builder: (context, dialogSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                actionsPadding: const EdgeInsets.all(16),

                title: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Keep only $newCount images",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),

                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Remove extra images until only $newCount remain.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 250,
                        child: GridView.builder(
                          itemCount: dialogImages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox.expand(
                                    child:
                                        dialogImages[index]!.type ==
                                            MediaType.image
                                        ? Image.file(
                                            File(dialogImages[index]!.path),
                                            fit: BoxFit.cover,
                                          )
                                        :  Stack(
                            fit: StackFit.expand,
                            children: [
                            VideoThumbnailWidget(
                            videoPath:  dialogImages[index]!.path,
                            ),

                            const Center(
                            child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 40,
                            ),
                            ),
                            ],
                            ),
                                    // Image.file(
                                    //   File(dialogImages[index]!.path),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),

                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Material(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        dialogSetState(() {
                                          dialogImages.removeAt(index);
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 6,
                                  bottom: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.pink.shade200,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: FilledButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey.shade300;
                              }
                              return Colors.pink.shade200;
                            }),
                            foregroundColor: MaterialStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey.shade500;
                              }
                              return Colors.white;
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: dialogImages.length == newCount
                              ? () {
                                  Navigator.pop(context, dialogImages);
                                }
                              : null,
                          icon: const Icon(Icons.check),
                          label: Text(
                            "Done (${dialogImages.length}/$newCount)",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
      if (remainingImages != null && remainingImages.length <= newCount) {
        selectedTemplates = newTemplates;
        count = newCount;

        List<MediaFile?> targetImages = getMediaOfTemplates(selectedTemplates);

        for (int i = 0; i < targetImages.length; i++) {
          targetImages[i] = null;
        }

        for (int i = 0; i < remainingImages.length; i++) {
          targetImages[i] = remainingImages[i];
        }

        setState(() {});
      }
    }
  }

  void showMediaOptions(List<MediaFile?> mediaList, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text("Preview"),
              onTap: () {
                Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FullScreenImage(media:  mediaList[index]!),
                    ),
                  );

              },
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Replace"),
              onTap: () async {
                Navigator.pop(context);
                await pickMedia(mediaList, index);
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove"),
              onTap: () {
                mediaList[index] = null;
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
              hasEntry ? "Edit Entry" : "Add Entry",
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
                if (selectDiary == null) {
                  return;
                }

                final mediaFiles = getMediaOfTemplates(
                  selectedTemplates,
                ).where((e) => e != null).cast<MediaFile>().toList();

                final diaryEntry = DiaryEntryModel(
                  diaryId: selectDiary.id!,
                  content: _contentController.text,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                  font: selectedFont,
                  mood: selectedMoods,
                  templateIndex: selectedTemplates.index,
                  mediaFiles: mediaFiles,
                  title: _titleController.text.trim(),
                  subtitle: _subtitleController.text.trim(),
                );

                if (_contentController.text.trim().isNotEmpty ||
                    _titleController.text.trim().isNotEmpty ||
                    _subtitleController.text.trim().isNotEmpty ||
                    mediaFiles.isNotEmpty) {
                  hasEntry = true;
                } else {
                  hasEntry = false;
                }

                try {
                  if (hasEntry) {
                    await DatabaseHelper.instance.insertDiaryEntry(diaryEntry);
                  } else {}

                  Navigator.pop(
                    context,
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                  );
                } catch (e, stackTrace) {
                  print(stackTrace);
                }
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
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TemplateScreen(),
                              ),
                            );
                            if (result != null) {
                              await changeTemplates(
                                templates[result["templateindex"]].templateType,
                                result["count"],
                              );
                            }
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
