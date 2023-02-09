// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'edit_dialog.dart';

class EditNumberDialog extends StatefulWidget {
  String title;
  String cancelLabel;
  String okLabel;
  num value;
  Function okClick;
  late TextEditingController textEditingController;
  EditNumberDialog({
    Key? key,
    required this.title,
    required this.cancelLabel,
    required this.okLabel,
    required this.value,
    required this.okClick,
    required this.textEditingController,
  }) : super(key: key) {
    textEditingController = TextEditingController(text: value.toString());
  }

  @override
  State<EditNumberDialog> createState() => _EditNumberDialogState();
}

class _EditNumberDialogState extends State<EditNumberDialog> {
  @override
  Widget build(BuildContext context) {
    return EditDialog(
        cancelLabel: widget.cancelLabel,
        okLabel: widget.okLabel,
        title: widget.title,
        okClick: () {
          if (widget.value is int) {
            widget.okClick(int.parse(widget.textEditingController.text));
          } else if (widget.value is double) {
            widget.okClick(double.parse(widget.textEditingController.text));
          }
        },
        widgetContent: TextField(
          keyboardType: (widget.value is double)
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: (widget.value is double)
              ? [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ]
              : [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
          controller: widget.textEditingController,
        ));
  }
}
