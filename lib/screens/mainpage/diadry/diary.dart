import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inner_me_application/core/style.dart';

class DiaryPage extends StatefulWidget {
  DiaryPage({super.key});

  @override
  State<DiaryPage> createState() {
    return _DiaryPageState();
  }
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/main/background.png'), fit: BoxFit.fill)
        )
      ),

      floatingActionButton:  FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
     
    );
  }
}