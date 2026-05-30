import 'package:diary/models/category_model.dart';
import 'package:diary/models/diary_model.dart';
import 'package:diary/models/theme_model.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

class DiaryState {
  final String name;
  final ThemeModel? themes;
  final CategoryModel? category;
  final bool isPrivate;
  final String? password;
  DiaryState({
    required this.name,
    required this.themes,
    required this.category,
    required this.isPrivate,
    required this.password,
  });
  DiaryState copyWith({
    String? name,
    ThemeModel? themes,
    CategoryModel? category,
    bool? isPrivate,
    String? password,
  }) {
    return DiaryState(
      name: name ?? this.name,
      themes: themes ?? this.themes,
      category: category ?? this.category,
      isPrivate: isPrivate ?? this.isPrivate,
      password: password ?? this.password,
    );
  }
}

class DiaryNotifier extends StateNotifier<DiaryState> {
  DiaryNotifier()
    : super(
        DiaryState(
          name: "",
          themes: null,
          category: null,
          isPrivate: false,
          password: null,
        ),
      );

  void updateTitle(String names) {
    state = state.copyWith(name: names);
  }

  void updateTheme(ThemeModel theme) {
    state = state.copyWith(themes: theme);
  }

  void updateCategory(CategoryModel category) {
    state = state.copyWith(category: category);
  }

  void updatePassword(bool isPrivate, String? password) {
    state = state.copyWith(isPrivate: isPrivate, password: password);

  }

}

final diaryProvider = StateNotifierProvider<DiaryNotifier, DiaryState>(
  (ref) => DiaryNotifier(),
);
