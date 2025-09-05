import 'dart:io';

import 'package:inner_me_application/core/model/diary_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DiaryFileServices {
  DiaryFileServices._singleton();
  static final DiaryFileServices instance = DiaryFileServices._singleton();
  Future<File> getDiaryFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/diary.txt");
  }

  String dateFormat = 'dd/MM/yyyy';

  Future<void> saveDiary(String text, DateTime date) async {
    String content = '';
    content += '=== ${DateFormat(dateFormat).format(date)} ===';
    content += text;

    final file = await getDiaryFile();

    await file.writeAsString(content, mode: FileMode.append); // ghi nối tiếp
  }

  String exportLogs(List<DiaryModel> logs) {
  return logs.map((log) => "=== ${DateFormat(dateFormat).format(log.startDate)} ===${log.content}").join("\n");
  }

  Future<void> updateDiary(int index, String text) async {
    final file = await getDiaryFile();
    var diary = await readDiary();
    diary[index].content = text;

    await file.writeAsString(exportLogs(diary), mode: FileMode.write); // ghi nối tiếp
  }

  Future<List<DiaryModel>> readDiary() async {
    try {
      final file = await getDiaryFile();
      final content = await file.readAsString();

      List<DiaryModel> entries = [];

      // Regex tìm các section
      final regex = RegExp(
        r"=== (\d{2}/\d{2}/\d{4}) ===(.*?)(?=(=== \d{2}/\d{2}/\d{4} ===)|$)",
        dotAll: true,
      );
      final matches = regex.allMatches(content);

      for (final m in matches) {
        final date = m.group(1)!;
        final text = m.group(2)!.trim();
        entries.add(DiaryModel(text, DateFormat(dateFormat).parse(date)));
      }
      return entries;
    } catch (e) {
      return [];
    }
  }
}
