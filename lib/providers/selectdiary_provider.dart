import 'package:diary/models/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDiaryNotifier extends StateNotifier<DiaryModel?>{
SelectedDiaryNotifier() :  super(null);
void selectDiary(DiaryModel diary){
  state=diary;

}
void clearDiary(){
  state=null;
}


}
final SelectedDiaryProvider=StateNotifierProvider<SelectedDiaryNotifier,DiaryModel?>((ref)=>SelectedDiaryNotifier());