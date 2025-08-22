import 'package:flutter/material.dart';
import 'package:inner_me_application/core/style.dart';

class DiskFolder extends StatelessWidget {

  late String folderName;
  DiskFolder({required this.folderName, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: IMAppColor.appWhite, width: 1)
      ),
      child: Column(
        children: [
          Icon(Icons.play_circle)
        ],
      ),
    );
    
  }
}