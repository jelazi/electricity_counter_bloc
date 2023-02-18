// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/f_logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../blogs/bloc_export.dart';

class PdfScreen extends StatelessWidget {
  late String pdfPath;
  var pdfController;
  var pdfViewController;
  PdfScreen({
    Key? key,
    required this.pdfPath,
  }) : super(key: key) {
    pdfController = PdfController(document: PdfDocument.openFile(pdfPath));
    pdfViewController = PdfController(
      document: PdfDocument.openFile(pdfPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              getDialogSaveFile(File(pdfPath), 'electricity.pdf', context);
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
          IconButton(
            onPressed: () async {
              final page =
                  await (await PdfDocument.openFile(pdfPath)).getPage(1);
              final pageImage = await page.render(
                width: page.width * 2,
                height: page.height * 2,
                format: PdfPageImageFormat.png,
                backgroundColor: '#ffffff',
              );
              File file = File(
                  '${(await getApplicationDocumentsDirectory()).path}/example.png');
              await file.writeAsBytes(pageImage!.bytes);
              getDialogSaveFile(file, 'electricity.png', context);
            },
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: PdfView(
        controller: pdfViewController,
      ),
    );
  }

  Future<void> getDialogSaveFile(
      File content, String nameFile, BuildContext context) async {
    if (Platform.isAndroid || Platform.isIOS) {
      File file = await content.rename(
          '${(await getApplicationDocumentsDirectory()).path}/$nameFile');
      String contentString = await content.readAsString();
      Share.share(contentString,
          sharePositionOrigin: Rect.fromLTWH(
              0,
              0,
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height / 2));
    }
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please write name json file:',
        fileName: nameFile,
      );
      if (outputFile == null) {
        FLog.warning(text: 'file picker cancel');
      } else {
        content.copy(outputFile);
      }
    }
  }
}
