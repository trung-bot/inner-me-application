import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_me_application/core/style.dart';
import 'package:intl/intl.dart';

class AddEditDiary extends StatefulWidget {
  final DateTime? date;
  const AddEditDiary({super.key, this.date});

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
    if (widget.date == null) {
      currentDate = DateTime.now();
    } else {
      currentDate = widget.date!;
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
            onPressed: () {
              context.pop(_controller.text);
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
                  style: const TextStyle(
                    
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none, 
                    hintText: "Hello world, ...",
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
}
