library file_logger;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// A Calculator.
class FileLogger {
  static Future<bool> writeToFile(String content, {String? fileName}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final filename = fileName ?? "$date.log.txt";
      final file = File('${directory.path}\\$filename');
      if (await file.exists()) {
        await file.writeAsString(content, mode: FileMode.append);
      } else {
        await file.writeAsString(content);
      }
      debugPrint("Операция записи в log ${file.path} файл успешно завершена");
      return true;
    } catch (e) {
      debugPrint("Ошибка при записи в log файл: $e");
      return false;
    }
  }

  static Future<List<File>> getLogsFiles() async {
    return getFiles(fileExtension: '.log.txt');
  }

  static Future<List<File>> getFiles({String? fileExtension}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();
      if (fileExtension != null) {
        return files.whereType<File>().where((file) => file.path.endsWith(fileExtension)).toList();
      }
      return files.whereType<File>().toList();
    } catch (e) {
      debugPrint("Ошибка при получении log файлов: $e");
      return [];
    }
  }

  static Future<void> deleteFileByPath(List<String> filesPaths) async {
    try {
      for (var filePath in filesPaths) {
        final file = File(filePath);

        if (await file.exists()) {
          await file.delete();
          debugPrint('Файл удален: $filePath');
        } else {
          debugPrint('Файл не найден: $filePath');
        }
      }
    } catch (e) {
      debugPrint('Ошибка при удалении лог файлов: $e');
    }
  }

  static Future<void> deleteAllLogFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logFiles = directory.listSync();

      for (var file in logFiles) {
        if (file is File && file.path.endsWith('.log.txt')) {
          await file.delete();
          debugPrint('Лог файл удален: ${file.path}');
        }
      }
    } catch (e) {
      debugPrint('Ошибка при удалении лог файлов: $e');
    }
  }

  static Future<void> deleteOlderLogFiles(Duration? duration) async {
    try {
      final timeDuration = duration ?? const Duration(days: 7);
      final files = await getLogsFiles();
      final now = DateTime.now();
      final olderFiles = files.where((file) {
        final name = file.path.split('\\').last;
        final date = name.split('.').first;
        final fileDate = DateFormat('dd-MM-yyyy').parse(date);
        final result = now.difference(fileDate).inDays > timeDuration.inDays;
        return result;
      }).toList();

      for (var file in olderFiles) {
        await file.delete();
        debugPrint('Лог файл удален: ${file.path}');
      }
    } catch (e) {
      debugPrint('Ошибка при удалении лог файлов: $e');
    }
  }
}
