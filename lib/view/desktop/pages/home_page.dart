// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:electricity_counter/view/widgets/edit_dialogs/edit_text_dialog.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../blogs/bloc_export.dart';
import '../../../localization/app_localizations.dart';
import '../../widgets/entry_card.dart';
import '../../widgets/name_user_card.dart';
import '../tables/table_enters.dart';

class HomePageDesktop extends StatefulWidget {
  HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

//test

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      var headerTableEnters = <Widget>[];
      headerTableEnters.add(Card(
          child: SizedBox(
              height: 60,
              width: 200,
              child: ListTile(
                  tileColor: Colors.red[50],
                  title: Text(
                      AppLocalizations.of(context).translate('datesEnter'))))));
      for (String id in state.users.keys) {
        headerTableEnters.add(
          NameUserCard(id: id, name: state.users[id] ?? ''),
        );
      }
      var rowsTableEnters = <Widget>[];
      var numberTableEnters = 0;
      var leftHeadertableEnters = <Widget>[];
      for (var month in state.months) {
        var cells = <Widget>[];
        leftHeadertableEnters.add(Card(
          child: SizedBox(
              height: 60, width: 200, child: ListTile(title: Text(month))),
        ));
        for (var i = 0; i < state.entries.length; i++) {
          cells.add(
            EntryCard(
              value: state.entries[i][state.months.indexOf(month)],
              idUser: state.users.keys.elementAt(i),
              date: month,
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
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    String title =
                        AppLocalizations.of(context).translate('addUser');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditTextDialog(
                            cancelLabel: AppLocalizations.of(context)
                                .translate('cancel'),
                            okLabel:
                                AppLocalizations.of(context).translate('ok'),
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
          TableEnters(
              number: numberTableEnters,
              header: headerTableEnters,
              leftHeader: leftHeadertableEnters,
              rows: rowsTableEnters),
        ],
      );
    })));
  }
}
