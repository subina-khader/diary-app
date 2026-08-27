
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:diary/models/diary_model.dart';
import 'package:diary/models/diaryentry_model.dart';
import 'package:diary/services/database_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
class BackupService {
  static Future<bool> createBackup() async {
    final diaries = await DatabaseHelper.instance.getDiary();

    final backupDiaries = <Map<String, dynamic>>[];
    final archive = Archive();

    for (final diary in diaries) {
      final entries = await DatabaseHelper.instance
          .getAllEntriesByDiaryId(diary.id!);

      final entryMaps = <Map<String, dynamic>>[];

      for (final entry in entries) {
        final entryMap = entry.toMap();

        if (entry.mediaFiles != null) {
          final mediaList = <Map<String, dynamic>>[];

          for (final media in entry.mediaFiles!) {
            final file = File(media.path);

            if (await file.exists()) {
              final fileName = p.basename(media.path);
              final archivePath = 'media/$fileName';

              final bytes = await file.readAsBytes();

              archive.addFile(
                ArchiveFile(
                  archivePath,
                  bytes.length,
                  bytes,
                ),
              );

              mediaList.add({
                'path': archivePath,
                'type': media.type.name,
              });
            }
          }

          entryMap['imagePaths'] = jsonEncode(mediaList);
        }

        entryMaps.add(entryMap);
      }

      backupDiaries.add({
        'diary': diary.toMap(),
        'entries': entryMaps,
      });
    }

    final backupData = {
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'diaries': backupDiaries,
    };

    final jsonBytes = utf8.encode(
      jsonEncode(backupData),
    );

    archive.addFile(
      ArchiveFile(
        'backup.json',
        jsonBytes.length,
        jsonBytes,
      ),
    );

    final zipBytes = ZipEncoder().encode(archive);

    if (zipBytes == null) {
      throw Exception('Failed to create backup');
    }

    // Android/iOS require bytes here
    final now = DateTime.now();


    final fileName =
        'diary_backup_${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}-'
        '${now.minute.toString().padLeft(2, '0')}-'
        '${now.second.toString().padLeft(2, '0')}.zip';
    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Diary Backup',
        fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['zip'],
      bytes: Uint8List.fromList(zipBytes),    );

    print('SAVE PATH RESULT: $savePath');

    if (savePath == null) {
      print('USER CANCELLED BACKUP');
      return false;
    }

    print('BACKUP SAVE RESULT: $savePath');

    return true;
  }
  static Future<bool> restoreBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null || result.files.single.path == null) {
      return false;
    }

    final file = File(result.files.single.path!);
    final zipBytes = await file.readAsBytes();

    final archive = ZipDecoder().decodeBytes(zipBytes);

    final backupFile = archive.findFile('backup.json');

    if (backupFile == null) {
      throw Exception('Invalid backup file');
    }

    final jsonString = utf8.decode(
      backupFile.content as List<int>,
    );

    final backupData = jsonDecode(jsonString);
    final diaries = backupData['diaries'] as List;

    final appDirectory =
    await getApplicationDocumentsDirectory();

    final mediaDirectory = Directory(
      '${appDirectory.path}/diary_media',
    );

    if (!await mediaDirectory.exists()) {
      await mediaDirectory.create(recursive: true);
    }

    for (final item in diaries) {
      final diaryMap = Map<String, dynamic>.from(
        item['diary'],
      );

      diaryMap.remove('id');

      final diary = DiaryModel.fromMap(diaryMap);

      final newDiaryId =
      await DatabaseHelper.instance.insertDiary(diary);

      final entries = item['entries'] as List;

      for (final entryData in entries) {
        final entryMap = Map<String, dynamic>.from(
          entryData,
        );

        entryMap.remove('entryId');

        entryMap['diaryId'] = newDiaryId;

        if (entryMap['imagePaths'] != null) {
          final mediaData = jsonDecode(
            entryMap['imagePaths'],
          ) as List;

          final restoredMedia = <Map<String, dynamic>>[];

          for (final media in mediaData) {
            final backupPath = media['path'] as String;

            final mediaFile = archive.findFile(backupPath);

            if (mediaFile == null) {
              continue;
            }

            final fileName = p.basename(backupPath);

            final restoredPath =
                '${mediaDirectory.path}/$fileName';

            final restoredFile = File(restoredPath);

            await restoredFile.writeAsBytes(
              mediaFile.content as List<int>,
            );

            restoredMedia.add({
              'path': restoredPath,
              'type': media['type'],
            });
          }

          entryMap['imagePaths'] =
              jsonEncode(restoredMedia);
        }

        final diaryEntry =
        DiaryEntryModel.fromMap(entryMap);

        await DatabaseHelper.instance.insertDiaryEntry(
          diaryEntry,
        );
      }
    }

    return true;
  }}

