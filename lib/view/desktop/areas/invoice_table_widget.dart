import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/view/desktop/pages/result_page.dart';
import 'package:electricity_counter/view/desktop/tables/table_invoices.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/select_date_dialog.dart';
import 'package:flutter/material.dart';

import '../../../blogs/bloc_export.dart';
import '../../widgets/edit_dialogs/add_invoice.dart';
import '../../widgets/invoice_card.dart';

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
            headerTableInvoices.add(InvoiceCard(
              text: state.invoices[id] ?? '',
              idInvoice: id,
            ));
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
                    icon: const Icon(Icons.inventory),
                    label: Text(('addInvoice').tr())),
                ElevatedButton.icon(
                    onPressed: () {
                      String title = ('sumResult').tr();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SelectDateDialog(
                              title: title,
                              okClick: (invoice, listEntry) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                            invoice: invoice,
                                            listEntries: listEntry,
                                          )),
                                );
                              },
                            );
                          });
                    },
                    icon: const Icon(Icons.summarize),
                    label: Text(('sumResult').tr())),
              ],
            )
          ]);
        },
      ),
    );
  }
}
