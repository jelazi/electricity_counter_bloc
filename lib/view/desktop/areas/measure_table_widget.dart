import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/services/enum.dart';
import 'package:electricity_counter/view/desktop/pages/reaorerable_view_page.dart';
import 'package:flutter/material.dart';

import '../../../blogs/bloc_export.dart';

import '../../widgets/edit_dialogs/add_measurement.dart';
import '../../widgets/edit_dialogs/edit_text_dialog.dart';
import '../../widgets/entry_card.dart';
import '../../widgets/name_user_card.dart';
import '../tables/table_enters.dart';

class MeasureTableWidget extends StatelessWidget {
  const MeasureTableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[50],
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
        var headerTableEnters = <Widget>[];
        headerTableEnters.add(Card(child: SizedBox(height: 60, width: 200, child: ListTile(tileColor: Colors.red[50], title: Text(('datesEnter').tr())))));
        for (String id in state.users.keys) {
          headerTableEnters.add(
            NameUserCard(id: id, name: state.users[id] ?? ''),
          );
        }
        var rowsTableEnters = <Widget>[];
        var numberTableEnters = 0;
        var leftHeadertableEnters = <Widget>[];
        for (var date in state.months) {
          var cells = <Widget>[];
          leftHeadertableEnters.add(Card(
            child: SizedBox(height: 60, width: 200, child: ListTile(title: Text(getNameMonth(date)))),
          ));
          for (var i = 0; i < state.entries.length; i++) {
            cells.add(
              EntryCard(
                value: state.entries[i][state.months.indexOf(date)],
                idUser: state.users.keys.elementAt(i),
                date: date,
                nt: state.nts[i][state.months.indexOf(date)],
                vt: state.vts[i][state.months.indexOf(date)],
              ),
            );
          }
          numberTableEnters = cells.length;
          rowsTableEnters.add(Row(
            children: cells,
          ));
        }
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TableEnters(number: numberTableEnters, header: headerTableEnters, leftHeader: leftHeadertableEnters, rows: rowsTableEnters),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      String title = ('addUser').tr();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditTextDialog(
                              okClick: (nameUser) => context.read<UsersBloc>().add(AddUser(nameUser: nameUser)),
                              title: title,
                              value: '',
                            );
                          });
                    },
                    icon: const Icon(Icons.person),
                    label: Text(('addUser').tr())),
                ElevatedButton.icon(
                    onPressed: () {
                      String title = ('reorderUsers').tr();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReorderableViewPage()),
                      );
                    },
                    icon: const Icon(Icons.sort),
                    label: Text(('reorderUsers').tr())),
                ElevatedButton.icon(
                    onPressed: () {
                      String title = ('addEnter').tr();

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddMeasurementDialog(
                              context: context,
                              title: title,
                              users: context.read<UsersBloc>().getCurrentUsers(),
                              okClick: (listEntries) {},
                            );
                          });
                    },
                    icon: const Icon(Icons.note),
                    label: Text(('addEnter').tr()))
              ],
            ),
          ],
        );
      }),
    );
  }
}
