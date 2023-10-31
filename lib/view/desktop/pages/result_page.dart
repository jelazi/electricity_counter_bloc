// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/view/desktop/pages/excel_page.dart';
import 'package:excel/excel.dart';
import 'package:f_logs/f_logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/services/enum.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/entry.dart';
import '../../../models/invoice.dart';
import '../../../models/result.dart';
import 'pdf_page.dart';

class ResultPage extends StatefulWidget {
  Invoice invoice;
  List<Entry> listEntries;
  var listName = <String>[];
  var listNameValue = [
    'name'.tr(),
    'ntEntry'.tr(),
    'percentNtEntry'.tr(),
    'priceNt'.tr(),
    'vtEntry'.tr(),
    'percentVtEntry'.tr(),
    'priceVt'.tr(),
    'fixPrice'.tr(),
    'sumPrice'.tr(),
  ];

  ResultPage({
    Key? key,
    required this.invoice,
    required this.listEntries,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final result = context.read<InvoicesBloc>().invoicesRepository.sumResult(
        widget.invoice,
        widget.listEntries,
        context.read<InvoicesBloc>().usersRepository);
    var number = 8;
    var header = widget.listNameValue.map((e) => HeaderCell(text: e)).toList();
    var leftHeader = List<Widget>.generate(result.listName.length,
        (index) => LeftHeaderCell(text: result.listName[index]));
    leftHeader.add(LeftHeaderCell(
      text: 'sum'.tr(),
      color: Colors.red[200],
    ));
    var rows = <Widget>[];
    List<double> listSum = List<double>.generate(8, (index) => 0);

    for (var row in result.listData) {
      var items = <Widget>[];
      listSum[0] += row[0];
      listSum[1] += row[1];
      listSum[2] += row[2];
      listSum[3] += row[3];
      listSum[4] += row[4];
      listSum[5] += row[8];
      listSum[6] += row[6];
      listSum[7] += row[7];
      items.add(RowCell(text: '${row[0]} kWh'));
      items.add(RowCell(text: '${row[1].toStringAsFixed(1)} %'));
      items.add(RowCell(text: '${row[2].toStringAsFixed(1)} Kč'));
      items.add(RowCell(text: '${row[3]} kWh'));
      items.add(RowCell(text: '${row[4].toStringAsFixed(1)} %'));
      items.add(RowCell(text: '${row[5].toStringAsFixed(2)} Kč'));
      items.add(RowCell(text: '${row[6].toStringAsFixed(2)} Kč'));
      items.add(RowCell(
        text: '${row[7].toStringAsFixed(2)} Kč',
        color: Colors.green[400],
      ));

      rows.add(SizedBox(
        width: 150,
        child: Row(
          children: items,
        ),
      ));
    }
    rows.add(SizedBox(
        child: Row(children: [
      RowCell(
        text: '${listSum[0]} kWh',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[1].toStringAsFixed(1)} %',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[2].toStringAsFixed(1)} Kč',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[3]} kWh',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[4].toStringAsFixed(1)} %',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[5].toStringAsFixed(2)} Kč',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[6].toStringAsFixed(2)} Kč',
        color: Colors.red[200],
      ),
      RowCell(
        text: '${listSum[7].toStringAsFixed(2)} Kč',
        color: Colors.red[200],
      ),
    ])));

    return Scaffold(
        appBar: AppBar(
          title: Text('${('result').tr()} ${getNameMonth(result.date)}'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black.withAlpha(40),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                child: HorizontalDataTable(
                  leftHandSideColumnWidth: 200,
                  rightHandSideColumnWidth: number * 150,
                  isFixedHeader: true,
                  headerWidgets: header,
                  isFixedFooter: false,
                  footerWidgets: header,
                  leftSideChildren: leftHeader,
                  rightSideChildren: rows,
                  rowSeparatorWidget: const Divider(
                    color: Colors.black38,
                    height: 1.0,
                    thickness: 2.0,
                  ),
                  rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String pdfPath = await makePdf(
                        context,
                        widget.listNameValue,
                      );
                      if (pdfPath.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfScreen(
                                    pdfPath: pdfPath,
                                  )),
                        );
                      }
                    },
                    child: Text('createPdf'.tr())),
                ElevatedButton(
                    onPressed: () {
                      var excel = Excel.createExcel();
                      Sheet sheetObject =
                          excel[getNameMonth(widget.invoice.date)];
                      final result = context
                          .read<InvoicesBloc>()
                          .invoicesRepository
                          .sumResult(widget.invoice, widget.listEntries,
                              context.read<InvoicesBloc>().usersRepository);

                      sheetObject.insertRowIterables(widget.listNameValue, 0);
                      for (var row in result.listData) {
                        List<String> line = [];
                        line.add(result.listName[result.listData.indexOf(row)]);
                        line.add('${row[0]} kWh');
                        line.add('${row[1].toStringAsFixed(1)} %');
                        line.add('${row[2].toStringAsFixed(1)} Kč');
                        line.add('${row[3]} kWh');
                        line.add('${row[4].toStringAsFixed(1)} %');
                        line.add('${row[5].toStringAsFixed(2)} Kč');
                        line.add('${row[6].toStringAsFixed(2)} Kč');
                        line.add('${row[7].toStringAsFixed(2)} Kč');
                        sheetObject.insertRowIterables(
                            line, result.listData.indexOf(row) + 1);
                      }

                      getDialogSaveExcel(excel, 'tabulka.xlsx', context);
                    },
                    child: Text('createExcel'.tr())),
              ],
            )
          ],
        ));
  }

  Future<void> getDialogSaveExcel(
      Excel excel, String nameFile, BuildContext context) async {
    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    var file = File("$nameFile")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    if (Platform.isAndroid || Platform.isIOS) {
      String contentString = await file.readAsString();
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
        file.copy(outputFile);
      }
    }
  }
}

Future<String> makePdf(BuildContext context, List listNameValue) async {
  var listEntry = context.read<UsersBloc>().currentListEntry;
  Invoice? invoice = context.read<InvoicesBloc>().currentInvoice;
  final result = context.read<InvoicesBloc>().invoicesRepository.sumResult(
      invoice!, listEntry, context.read<InvoicesBloc>().usersRepository);
  if (listEntry.isEmpty || invoice == null) {
    FLog.debug(text: 'listEntry or invoice is null');
    return '';
  }

  var myTheme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load(
      "assets/fonts/arial.ttf",
    )),
  );
  var tableRow = <pw.TableRow>[];

  var header = pw.TableRow(
      children: listNameValue.map((e) => getPdfHeaderCell(e)).toList());

  tableRow.add(header);

  var leftHeader = List<pw.Container>.generate(
      result.listName.length, (index) => getPdfLeftHeaderCell(result, index));
  var listTableRow = List<List<Widget>>.generate(leftHeader.length,
      (index) => List<Widget>.generate(8, (j) => Container()));

  for (var row in result.listData) {
    var items = <pw.Container>[];
    items.add(getPdfLeftHeaderCell(result, result.listData.indexOf(row)));
    items.add(getPdfTableCell(text: '${row[0]} kWh'));
    items.add(getPdfTableCell(text: '${row[1].toStringAsFixed(1)} %'));
    items.add(getPdfTableCell(text: '${row[2].toStringAsFixed(1)} Kč'));
    items.add(getPdfTableCell(text: '${row[3]} kWh'));
    items.add(getPdfTableCell(text: '${row[4].toStringAsFixed(1)} %'));
    items.add(getPdfTableCell(text: '${row[5].toStringAsFixed(2)} Kč'));
    items.add(getPdfTableCell(text: '${row[6].toStringAsFixed(2)} Kč'));
    items.add(getPdfTableCell(
      text: '${row[7].toStringAsFixed(2)} Kč',
      color: PdfColors.green100,
    ));
    tableRow.add(pw.TableRow(children: items));
  }

  final pdfDocumemt = pw.Document(
    theme: myTheme,
  );
  pdfDocumemt.addPage(pw.Page(
      build: (pw.Context context) => pw.Container(
            child: pw.Table(children: tableRow),
          )));

  final file = File('example.pdf');
  if (!file.existsSync()) {
    await file.create(recursive: false);
  }
  await file.writeAsBytes(
    await pdfDocumemt.save(),
  );
  return file.path;
}

pw.Container getPdfTableCell({required String text, PdfColor? color}) {
  var fontSize = 6.0;
  return pw.Container(
      padding: pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        color: color ?? PdfColors.white,
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: fontSize),
      ));
}

pw.Container getPdfLeftHeaderCell(Result result, int index) {
  var fontSize = 6.0;
  return pw.Container(
      padding: pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        color: PdfColors.yellow,
      ),
      child: pw.Text(
        result.listName[index],
        style: pw.TextStyle(fontSize: fontSize),
      ));
}

pw.Container getPdfHeaderCell(String text) {
  var fontSize = 6.0;
  return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        color: PdfColors.blue100,
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: fontSize),
      ));
}

class LeftHeaderCell extends StatelessWidget {
  String text;
  Color? color;
  LeftHeaderCell({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: color ?? Colors.yellow),
        width: 150,
        height: 40,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ));
  }
}

class RowCell extends StatelessWidget {
  String text;
  Color? color;
  RowCell({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        width: 150,
        height: 40,
        child: Text(text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            )));
  }
}

class HeaderCell extends StatelessWidget {
  String text;

  HeaderCell({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), color: Colors.blue[50]),
        width: 150,
        height: 80,
        child: Text(text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )));
  }
}
