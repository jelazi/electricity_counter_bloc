// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'edit_dialog.dart';

class EditTextDialog extends StatefulWidget {
  String title;

  String value;
  Function okClick;
  late TextEditingController textEditingController;
  EditTextDialog({
    Key? key,
    required this.title,
    required this.value,
    required this.okClick,
  }) : super(key: key) {
    textEditingController = TextEditingController(text: value);
  }

  @override
  State<EditTextDialog> createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<EditTextDialog> {
  @override
  Widget build(BuildContext context) {
    return EditDialog(
        title: widget.title,
        okClick: () {
          widget.okClick(widget.textEditingController.text);
        },
        widgetContent: TextField(
          controller: widget.textEditingController,
        ));
  }
}
