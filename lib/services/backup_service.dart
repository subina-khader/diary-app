import 'dart:convert';
import 'dart:io';

import 'package:diary/services/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<void> createBackup() async {
    final diaries = await DatabaseHelper.instance.getDiary();

    final List<Map<String, dynamic>> backupDiaries = [];

    for (final diary in diaries) {
      final entries = await DatabaseHelper.instance
          .getAllEntriesByDiaryId(diary.id!);

      backupDiaries.add({
        "diary": diary.toMap(),
        "entries": entries.map((entry) => entry.toMap()).toList(),
      });
    }

    final backupData = {
      "version": 1,
      "createdAt": DateTime.now().toIso8601String(),
      "diaries": backupDiaries,
    };

    final directory = await getTemporaryDirectory();

    final file = File(
      '${directory.path}/diary_backup.json',
    );

    await file.writeAsString(
      jsonEncode(backupData),
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'My Diary Backup',
    );
  }
}