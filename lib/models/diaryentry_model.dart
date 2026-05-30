import 'dart:ui';

class DiaryEntryModel {
  final int? id;
  final int diaryId;
  final String content;
  final String date;
  DiaryEntryModel({this.id, required this.diaryId, required this.content,required this.date});

  Map<String, dynamic> toMap() {
    return {
      if(id!= null)
      "entryId": id, "diaryId": diaryId, "content": content,"entryDate":date};
  //"field":value=> field(table key) , value(modelkey)

  }

  factory DiaryEntryModel.fromMap(Map<String, dynamic> map) {
    return DiaryEntryModel(
      id: map["entryId"],
      diaryId: map["diaryId"],
      content: map["content"],
      date: map["entryDate"],
    );
  }
}
