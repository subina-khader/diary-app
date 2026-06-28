import 'dart:io';
import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/media_model.dart';
import '../providers/selectdiary_provider.dart';
import '../widgets/video_thumbnail.dart';
import 'adddiary/add_diaryentry.dart';
import 'full_screen_image.dart';

class ViewDiary extends ConsumerStatefulWidget {
  const ViewDiary({super.key});

  @override
  ConsumerState<ViewDiary> createState() => _ViewDiaryState();
}

class _ViewDiaryState extends ConsumerState<ViewDiary> {
  late PageController _pageController;
  List<DiaryEntryModel> entries = [];

  int currentPage = 0;
  DateTime? selectedCalenderDate;

  Future<int?> datePicker() async {
    if (entries.isEmpty) return null;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedCalenderDate ?? DateTime.parse(entries.last.date),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      selectableDayPredicate: (day) {
        return entries.any(
          (entry) => entry.date == DateFormat('yyyy-MM-dd').format(day),
        );
      },
    );

    if (pickedDate != null) {
      selectedCalenderDate = pickedDate;
      final index = entries.indexWhere(
        (entry) => entry.date == DateFormat('yyyy-MM-dd').format(pickedDate),
      );
      return index;
    }
    return null;
  }
  Widget mediaTile(MediaFile media) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenImage(
                media: media,
              ),
            ),
          );
        },
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.pink.shade100,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: buildMediaView(media),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget selectTemplates(int templateIndex, int index) {
    switch (templateIndex) {
      case 0:
        return plainsWidget(index);
      case 1:
        return topWidget(index);
      case 2:
        return doubleTopWidget(index);
      case 3:
        return bottomWidget(index);
      case 4:
        return doubleBottomWidget(index);
      case 5:
        return leftWidget(index);
      case 6:
        return rightWidget(index);
      case 7:
        return imageWidget(index);
      default:
        return plainsWidget(index);
    }
  }

  Widget buildMediaView(MediaFile media) {
    if (media.type == MediaType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(media.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        VideoThumbnailWidget(
          videoPath: media.path,
        ),

        Container(
          color: Colors.black26,
        ),

        const Center(
          child: Icon(
            Icons.play_circle_fill,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }
  Widget plainWidget(int index) {
    return Text(
      entries[index].content,
      style: TextStyle(color: Colors.black, fontFamily: entries[index].font),
    );
  }

  Widget plainsWidget(int index) {
    return Expanded(
      child: SingleChildScrollView(
        child: Text(
          entries[index].content,
          style: TextStyle(
            color: Colors.black,
            fontFamily: entries[index].font,
          ),
        ),
      ),
    );
  }

  Widget topWidget(int index) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(entries[index].mediaFiles!.length, (
                count,
              ) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              }),
            ),
            SizedBox(height: 20),

            plainWidget(index),
          ],
        ),
      ),
    );
  }

  Widget doubleTopWidget(int index) {
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
              itemCount: entries[index].mediaFiles?.length,
              itemBuilder: (context, count) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              },
            ),

            SizedBox(height: 20),

            plainWidget(index),
          ],
        ),
      ),
    );
  }

  Widget bottomWidget(int index) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            plainWidget(index),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(entries[index].mediaFiles!.length, (
                count,
              ) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftWidget(int index) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(entries[index].mediaFiles!.length, (
                count,
              ) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              }),
            ),
          ),
          SizedBox(width: 7),

          Expanded(child: plainWidget(index)),
        ],
      ),
    );
  }

  Widget rightWidget(int index) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: plainWidget(index)),
          SizedBox(width: 7),
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(entries[index].mediaFiles!.length, (
                count,
              ) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget(int index) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              entries[index].title!,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: entries[index].font,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              entries[index].subtitle!,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: entries[index].font,
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
              itemCount: entries[index].mediaFiles?.length,
              itemBuilder: (context, count) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget doubleBottomWidget(int index) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            plainWidget(index),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,

              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: entries[index].mediaFiles?.length,
              itemBuilder: (context, count) {
                return mediaTile(
                  entries[index].mediaFiles![count],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final diary = ref.read(SelectedDiaryProvider);
    if (diary == null) return;
    entries = await DatabaseHelper.instance.getAllEntriesByDiaryId(diary.id!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedDiary = ref.read(SelectedDiaryProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.brown),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.brown),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Diary is empty",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Caveat",
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Click the + button to start writing your diary",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Caveat",
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : PageView.builder(
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat.yMMMd().format(
                                          DateTime.parse(entries[index].date),
                                        ),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: entries[index].font,
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          int? index = await datePicker();
                                          if (index != null) {
                                            _pageController.animateToPage(
                                              index,
                                              duration: Duration(
                                                milliseconds: 23,
                                              ),
                                              curve: Curves.easeIn,
                                            );
                                            selectTemplates(
                                              entries[index].templateIndex,
                                              index,
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 19,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  selectTemplates(
                                    entries[index].templateIndex,
                                    index,
                                  ),

                                ],
                              ),
                            );
                          },
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        onPressed: () async {
          String? passedDate = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDiaryentry()),
          );
          await loadEntries();
          if (passedDate != null) {
            int pageindex = entries.indexWhere((e) => e.date == passedDate);
            _pageController.jumpToPage(pageindex);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
