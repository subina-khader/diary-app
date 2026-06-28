

import 'dart:convert';

import 'media_model.dart';

class DiaryEntryModel {
  final int? id;
  final int diaryId;
  final String content;
  final String date;
  final String font;
  final String mood;
  final int templateIndex;
  final List<MediaFile>? mediaFiles;
  final String? title;
  final String? subtitle;
  DiaryEntryModel({
    this.id,
    required this.diaryId,
    required this.content,
    required this.date,
    required this.font,
    required this.mood,
    required this.templateIndex,
    this.mediaFiles,
    this.title,
    this.subtitle,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "entryId": id,
      "diaryId": diaryId,
      "content": content,
      "entryDate": date,
      "font": font,
      "mood": mood,
      "templateIndex": templateIndex,
      if (mediaFiles != null)
        "imagePaths": jsonEncode(
          mediaFiles!
              .map((e) => e.toJson())
              .toList(),
        ),
      if (title != null) "title": title,
      if (subtitle != null) "subtitle": subtitle,
    };
    //"field":value=> field(table key) , value(modelkey)
  }

  factory DiaryEntryModel.fromMap(Map<String, dynamic> map) {
    return DiaryEntryModel(
      id: map["entryId"],
      diaryId: map["diaryId"],
      content: map["content"],
      date: map["entryDate"],
      font: map["font"],
      mood: map["mood"],
      templateIndex: map["templateIndex"],
      mediaFiles: map["imagePaths"] != null
          ? (jsonDecode(map["imagePaths"]) as List)
          .map(
            (e) => MediaFile.fromJson(e),
      )
          .toList()
          : null,
      title: map["title"],
      subtitle: map["subtitle"],
    );
  }
}
