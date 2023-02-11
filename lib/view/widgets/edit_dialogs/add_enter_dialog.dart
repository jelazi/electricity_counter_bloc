// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/user.dart';
import '../../../services/enum.dart';

class AddEnterDialog extends StatefulWidget {
  double nt = 0;
  double vt = 0;
  DateTime month;
  User user;
  TextEditingController ntController = TextEditingController();
  TextEditingController vtController = TextEditingController();
  AddEnterDialog({
    Key? key,
    required this.month,
    required this.user,
    this.nt = 0,
    this.vt = 0,
  }) : super(key: key) {
    if (nt != 0) {
      ntController.text = nt.toString();
    }
    if (vt != 0) {
      vtController.text = vt.toString();
    }
  }

  @override
  State<AddEnterDialog> createState() => _AddEnterDialogState();
}

class _AddEnterDialogState extends State<AddEnterDialog> {
  @override
  Widget build(BuildContext context) {
    return EditDialog(
        width: 400,
        title:
            '${'addEnter'.tr()} ${getNameMonth(widget.month)} ${widget.user.name}',
        okClick: () {
          context.read<UsersBloc>().add(AddEntry(
              idUser: widget.user.id,
              date: widget.month,
              nt: double.parse(widget.ntController.text),
              vt: double.parse(widget.vtController.text)));
        },
        widgetContent: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  'NT: ',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    controller: widget.ntController,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text('kVh'),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  'VT: ',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    controller: widget.vtController,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text('kVh'),
              ],
            ),
          ],
        ));
  }
}
