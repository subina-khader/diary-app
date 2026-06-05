

import 'dart:convert';

class DiaryEntryModel {
  final int? id;
  final int diaryId;
  final String content;
  final String date;
  final String font;
  final String mood;
  final int templateIndex;
  final List<String>? imagePaths;
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
    this.imagePaths,
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
      if (imagePaths != null) "imagePaths": jsonEncode(imagePaths),
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
      imagePaths: map["imagePaths"] != null
          ? List<String>.from(jsonDecode(map["imagePaths"]))
          : null,
      title: map["title"],
      subtitle: map["subtitle"],
    );
  }
}
