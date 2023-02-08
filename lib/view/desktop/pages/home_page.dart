// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_table_2/data_table_2.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/edit_text_dialog.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import '../../../blogs/bloc_export.dart';
import '../../../localization/app_localizations.dart';
import '../../widgets/entry_card.dart';
import '../../widgets/name_user_card.dart';

class HomePageDesktop extends StatefulWidget {
  HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      var columns = <DataColumn2>[];
      columns.add(const DataColumn2(fixedWidth: 250, label: Text('months')));
      for (String id in state.users.keys) {
        columns.add(DataColumn2(
            fixedWidth: 300,
            label: NameUserCard(id: id, name: state.users[id] ?? '')));
      }
      var rows = <DataRow>[];
      for (var month in state.months) {
        var cells = <DataCell>[];
        cells.add(DataCell(Text(month)));
        for (var i = 0; i < state.entries.length; i++) {
          cells.add(DataCell(
            EntryCard(
              value: state.entries[i][state.months.indexOf(month)],
              idUser: state.users.keys.elementAt(i),
              date: month,
            ),
          ));
        }
        rows.add(DataRow(cells: cells));
      }
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    String title = 'addUser';
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditTextDialog(
                            okClick: (nameUser) => context
                                .read<UsersBloc>()
                                .add(AddUser(nameUser: nameUser)),
                            title: title,
                            value: '',
                          );
                        });
                  },
                  icon: const Icon(Icons.person),
                  label:
                      Text(AppLocalizations.of(context).translate('addUser'))),
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.note),
                  label:
                      Text(AppLocalizations.of(context).translate('addEnter')))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              color: Color.fromARGB(255, 236, 240, 246),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable2(
                    fixedLeftColumns: 1,
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 1200,
                    headingRowColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 126, 195, 251)),
                    columns: columns,
                    rows: rows),
              )),
        ],
      );
    })));
  }
}
