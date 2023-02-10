import 'package:electricity_counter/view/desktop/tables/table_invoices.dart';
import 'package:flutter/material.dart';

import '../../../localization/app_localizations.dart';
import '../../../blogs/bloc_export.dart';

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
          headerTableInvoices.add(
              Text(AppLocalizations.of(context).translate('itemsInvoices')));
          for (String id in state.invoices.keys) {
            headerTableInvoices.add(Text(state.invoices[id] ?? ''));
          }
          var rowsTableInvoices = <Widget>[];
          var numberTableInvoices = 0;
          var leftHeadertableInvoices = <Widget>[
            Text(AppLocalizations.of(context).translate('fixRate')),
            Text(AppLocalizations.of(context).translate('floatingRateNT')),
            Text(AppLocalizations.of(context).translate('floatingRateVT')),
          ];

          for (var invoice in state.invoicesData) {
            var cells = <Widget>[];
            for (var data in invoice) {
              cells.add(Text(data));
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
                    onPressed: () {},
                    icon: Icon(Icons.inventory),
                    label: Text(
                        AppLocalizations.of(context).translate('addInvoice'))),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.summarize),
                    label: Text(
                        AppLocalizations.of(context).translate('sumResult'))),
              ],
            )
          ]);
        },
      ),
    );
  }
}
