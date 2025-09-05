import 'package:flutter/material.dart';
import 'package:inner_me_application/core/model/diary_model.dart';
import 'package:inner_me_application/core/services/file/diary_file.services.dart';
import 'package:inner_me_application/core/style.dart';
import 'package:intl/intl.dart';

class AddEditDiary extends StatefulWidget {
  final int? index;
  final DiaryModel? item;
  const AddEditDiary({super.key, this.index, this.item});

  @override
  State<AddEditDiary> createState() {
    return _AddEditDiaryState();
  }
}

class _AddEditDiaryState extends State<AddEditDiary> {
  late DateTime currentDate;
  @override
  void initState() {
    super.initState();
    if (widget.item == null) {
      // add new diary
      currentDate = DateTime.now();
    } else {
      currentDate = widget.item!.startDate;
      _controller.text = widget.item!.content;
    }
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('dd/MM/yyyy').format(currentDate),
          style: theme.textTheme.headlineSmall!,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (widget.index != null) {
                await DiaryFileServices.instance.updateDiary(
                  widget.index!,
                  _controller.text,
                );

                if (!mounted) return;
                final ctx = context; // ✅ capture context safely
                await showSuccessDialog(ctx, 'Update Diary Success');
                Navigator.pop(ctx, _controller.text);
              } else {
                await DiaryFileServices.instance.saveDiary(
                  _controller.text,
                  currentDate,
                );

                if (!mounted) return;
                final ctx = context; // ✅ capture context safely
                await showSuccessDialog(ctx, 'Create Diary Success');
                Navigator.pop(ctx, _controller.text);
              }
            },
            child: Text('Done', style: theme.textTheme.headlineSmall!),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: IMAppColor.appBlack,
                child: TextField(
                  autofocus: true,
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Hello world ...",
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
