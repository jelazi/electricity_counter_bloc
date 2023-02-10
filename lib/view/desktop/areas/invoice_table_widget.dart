import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/view/desktop/pages/invoice_page.dart';
import 'package:electricity_counter/view/desktop/tables/table_invoices.dart';
import 'package:flutter/material.dart';

import '../../../blogs/bloc_export.dart';
import '../../widgets/edit_dialogs/add_invoice.dart';

class InvoiceTableWidget extends StatelessWidget {
  const InvoiceTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      height: MediaQuery.of(context).size.height * 0.5,
      child: BlocBuilder<InvoicesBloc, InvoicesState>(
        builder: (context, state) {
          var headerTableInvoices = <Widget>[];
          headerTableInvoices.add(Card(
            child: SizedBox(
                width: 210,
                child: ListTile(
                  title: Text(('itemsInvoices').tr()),
                )),
          ));
          for (String id in state.invoices.keys) {
            headerTableInvoices.add(Card(
                child: SizedBox(
                    width: 210,
                    child: ListTile(title: Text(state.invoices[id] ?? '')))));
          }
          var rowsTableInvoices = <Widget>[];
          var numberTableInvoices = headerTableInvoices.length;
          var leftHeadertableInvoices = <Widget>[
            Card(
              child: SizedBox(
                  width: 200, child: ListTile(title: Text(('fixRate').tr()))),
            ),
            Card(
                child: SizedBox(
                    width: 200,
                    child: ListTile(
                      title: Text(('floatingRateNT').tr()),
                    ))),
            Card(
                child: SizedBox(
                    width: 200,
                    child: ListTile(
                      title: Text(('floatingRateVT').tr()),
                    ))),
          ];

          for (var invoice in state.invoicesData) {
            var cells = <Widget>[];
            for (var data in invoice) {
              cells.add(Card(
                  child: SizedBox(
                      width: 210, child: ListTile(title: Text(data)))));
            }
            rowsTableInvoices.add(Row(children: cells));
          }

          return Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TableInvoices(
                number: numberTableInvoices,
                header: headerTableInvoices,
                leftHeader: leftHeadertableInvoices,
                rows: rowsTableInvoices),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      String title = ('addInvoice').tr();

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddInvoiceDialog(
                              context: context,
                              title: title,
                              okClick: (listEntries) {},
                            );
                          });
                    },
                    icon: Icon(Icons.inventory),
                    label: Text(('addInvoice').tr())),
                ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InvoicesPage()),
                      );
                    },
                    icon: Icon(Icons.summarize),
                    label: Text(('sumResult').tr())),
              ],
            )
          ]);
        },
      ),
    );
  }
}
