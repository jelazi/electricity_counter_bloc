// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../localization/app_localizations.dart';

class EditDialog extends StatelessWidget {
  String title;

  Function okClick;
  Widget widgetContent;
  double height = 200;
  double width = 300;
  bool okBack = true;
  EditDialog({
    Key? key,
    required this.title,
    required this.okClick,
    required this.widgetContent,
    this.height = 200,
    this.width = 300,
    this.okBack = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            )),
        height: 60,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: const EdgeInsets.all(5.0),
      content: Container(
        padding: const EdgeInsets.all(8),
        height: height,
        width: width,
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          widgetContent,
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context).translate('cancel'),
                    )),
                ElevatedButton(
                    onPressed: () {
                      okClick();
                      if (okBack) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(AppLocalizations.of(context).translate('ok'))),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
