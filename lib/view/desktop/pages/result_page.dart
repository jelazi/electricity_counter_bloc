// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/services/enum.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../models/entry.dart';
import '../../../models/invoice.dart';
import '../../../models/result.dart';
import 'pdf_page.dart';

class ResultPage extends StatefulWidget {
  Invoice invoice;
  List<Entry> listEntries;
  var listName = <String>[];

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
    var number = 9;
    var header = [
      HeaderCell(text: 'name'.tr()),
      HeaderCell(text: 'ntEntry'.tr()),
      HeaderCell(text: 'percentNtEntry'.tr()),
      HeaderCell(text: 'priceNt'.tr()),
      HeaderCell(text: 'vtEntry'.tr()),
      HeaderCell(text: 'percentVtEntry'.tr()),
      HeaderCell(text: 'priceVt'.tr()),
      HeaderCell(text: 'fixPrice'.tr()),
      HeaderCell(text: 'sumPrice'.tr()),
      HeaderCell(text: 'ratioNtVt'.tr()),
    ];
    var leftHeader = List<Widget>.generate(result.listName.length,
        (index) => LeftHeaderCell(text: result.listName[index]));
    var rows = <Widget>[];

    for (var row in result.listData) {
      var items = <Widget>[];

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
      items.add(RowCell(
          text:
              '${row[8].toStringAsFixed(1)}% / ${row[9].toStringAsFixed(1)}%'));

      rows.add(SizedBox(
        width: 150,
        child: Row(
          children: items,
        ),
      ));
      var lastItems = <Widget>[];
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('${('result').tr()} ${getNameMonth(result.date)}'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
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
                      String pdfPath = await makePdf(context);
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
                    onPressed: () {}, child: Text('createExcel'.tr())),
              ],
            )
          ],
        ));
  }
}

Future<String> makePdf(BuildContext context) async {
  var listEntry = context.read<UsersBloc>().currentListEntry;
  var invoice = context.read<InvoicesBloc>().currentInvoice;
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

  var header = pw.TableRow(children: [
    getHeaderCell('name'.tr()),
    getHeaderCell('ntEntry'.tr()),
    getHeaderCell('percentNtEntry'.tr()),
    getHeaderCell('priceNt'.tr()),
    getHeaderCell('vtEntry'.tr()),
    getHeaderCell('percentVtEntry'.tr()),
    getHeaderCell('priceVt'.tr()),
    getHeaderCell('fixPrice'.tr()),
    getHeaderCell('sumPrice'.tr()),
    getHeaderCell('ratioNtVt'.tr()),
  ]);

  tableRow.add(header);

  var leftHeader = List<pw.Container>.generate(
      result.listName.length, (index) => getLeftHeaderCell(result, index));
  var listTableRow = List<List<Widget>>.generate(leftHeader.length,
      (index) => List<Widget>.generate(10, (j) => Container()));

  for (var row in result.listData) {
    var items = <pw.Container>[];
    items.add(getLeftHeaderCell(result, result.listData.indexOf(row)));
    items.add(getTableCell(text: '${row[0]} kWh'));
    items.add(getTableCell(text: '${row[1].toStringAsFixed(1)} %'));
    items.add(getTableCell(text: '${row[2].toStringAsFixed(1)} Kč'));
    items.add(getTableCell(text: '${row[3]} kWh'));
    items.add(getTableCell(text: '${row[4].toStringAsFixed(1)} %'));
    items.add(getTableCell(text: '${row[5].toStringAsFixed(2)} Kč'));
    items.add(getTableCell(text: '${row[6].toStringAsFixed(2)} Kč'));
    items.add(getTableCell(
      text: '${row[7].toStringAsFixed(2)} Kč',
      color: PdfColors.green100,
    ));
    items.add(getTableCell(
        text: '${row[8].toStringAsFixed(1)}% / ${row[9].toStringAsFixed(1)}%'));
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

pw.Container getTableCell({required String text, PdfColor? color}) {
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

pw.Container getLeftHeaderCell(Result result, int index) {
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

pw.Container getHeaderCell(String text) {
  var fontSize = 6.0;
  return pw.Container(
      padding: pw.EdgeInsets.all(2),
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
  LeftHeaderCell({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), color: Colors.yellow),
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
