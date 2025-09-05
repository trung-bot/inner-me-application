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

  

  Future<void> _readDiary() async {
    var response = await DiaryFileServices.instance.readDiary();
    setState(() {
      dataSources = response;
    });
  }

  onEditItem(index, DiaryModel item) {
    showDialog(
      context: context,
      builder: (context) => AddEditDiary(item: item, index: index,),
    ).then((content) {
      _readDiary();
    });
  }

  @override
  void initState() {
    super.initState();
    _readDiary();
  }

  Widget _buildListItem(context, index) {
    var item = dataSources[index];
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 20),
      child: InkWell(
        onTap: () {
          onEditItem(index, item);
        },
        child: DiaryItem(item.content, item.startDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
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
            _readDiary();
          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
