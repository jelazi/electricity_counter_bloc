// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/services/enum.dart';

import '../../../models/entry.dart';
import '../../../models/invoice.dart';
import '../../../models/result.dart';

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
              height: MediaQuery.of(context).size.height * 0.01,
            )
          ],
        ));
  }
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
