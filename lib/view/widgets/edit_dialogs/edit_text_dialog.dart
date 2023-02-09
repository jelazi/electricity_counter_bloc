// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'edit_dialog.dart';

class EditTextDialog extends StatefulWidget {
  String title;
  String cancelLabel;
  String okLabel;
  String value;
  Function okClick;
  late TextEditingController textEditingController;
  EditTextDialog({
    Key? key,
    required this.title,
    required this.cancelLabel,
    required this.okLabel,
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
        cancelLabel: widget.cancelLabel,
        okLabel: widget.okLabel,
        title: widget.title,
        okClick: () {
          widget.okClick(widget.textEditingController.text);
        },
        widgetContent: TextField(
          controller: widget.textEditingController,
        ));
  }
}
