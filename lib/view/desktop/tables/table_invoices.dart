// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class TableInvoices extends StatelessWidget {
  final int number;
  final List<Widget> header;
  final List<Widget> leftHeader;
  final List<Widget> rows;
  const TableInvoices({
    Key? key,
    required this.number,
    required this.header,
    required this.leftHeader,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 236, 240, 246),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: HorizontalDataTable(
            leftHandSideColumnWidth: 200,
            rightHandSideColumnWidth: number * 210,
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
            leftHandSideColBackgroundColor: Colors.white10,
            rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
          )),
    );
  }
}
