import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class TableEnters extends StatelessWidget {
  final int number;
  final List<Widget> header;
  final List<Widget> leftHeader;
  final List<Widget> rows;
  const TableEnters({
    super.key,
    required this.number,
    required this.header,
    required this.leftHeader,
    required this.rows,
  });

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
            leftHandSideColBackgroundColor:
                const Color.fromARGB(255, 177, 229, 126),
            rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
          ),
        ));
  }
}
