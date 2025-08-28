import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inner_me_application/screens/mainpage/diadry/add_edit_diary.dart';
import 'package:path_provider/path_provider.dart';
class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() {
    return _DiaryPageState();
  }
}

class _DiaryPageState extends State<DiaryPage> {
  late dynamic dataSources;
   // get path file diary.txt
  Future<File> _getDiaryFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/diary.txt");
  }

  Future<void> _saveDiary(String text) async {
    final file = await _getDiaryFile();
    print('file----');
    print(file);

    await file.writeAsString("$text\n", mode: FileMode.append); // ghi nối tiếp
  }

  Future<void> _readDiary() async {
    try {
      final file = await _getDiaryFile();
      final content = await file.readAsString();
      setState(() {
        dataSources = content;
        print(dataSources);
      });
    } catch (e) {
      setState(() {
        dataSources = "Chưa có nhật ký nào!";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _readDiary();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/main/background.png'), fit: BoxFit.fill)
        )
      ),

      floatingActionButton:  FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context) => AddEditDiary()).then((v) {
            _saveDiary('312312');
          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
     
    );
  }
}