import 'package:flutter/material.dart';
import 'package:inner_me_application/core/model/diary_model.dart';
import 'package:inner_me_application/core/services/file/diary_file.services.dart';
import 'package:inner_me_application/screens/mainpage/diadry/add_edit_diary.dart';
import 'package:inner_me_application/screens/mainpage/diadry/diary_item.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() {
    return _DiaryPageState();
  }
}

class _DiaryPageState extends State<DiaryPage> {
  late List<DiaryModel> dataSources = [];

  Future<void> _saveDiary(String text, DateTime date) async {

    DiaryFileServices.instance.saveDiary(text, date).then((x) {
      if (mounted) {
        showSuccessDialog(context, 'Create Diary Success').then((v) {
          _readDiary();
        });
      }
    });
  }

  Future showSuccessDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[50],
          title: const Text("Success", style: TextStyle(color: Colors.green)),
          content: Text(message, style: const TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _readDiary() async {
    var response = await DiaryFileServices.instance.readDiary();
    setState(() {
      dataSources = response;
    });
  }

  @override
  void initState() {
    super.initState();
    _readDiary();
  }

  Widget _buildListItem(context, index) {
    var item = dataSources[index];
    return Padding(padding: EdgeInsetsGeometry.only(bottom: 20), 
    child: DiaryItem(item.content, 
    
   item.startDate),) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  _buildListItem,
                  childCount: dataSources.length,
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddEditDiary(),
          ).then((v) {
            _saveDiary(v, DateTime.now());
          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
