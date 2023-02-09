// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:electricity_counter/view/widgets/edit_dialogs/edit_text_dialog.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import 'package:horizontal_data_table/horizontal_data_table.dart';

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
      var header = <Widget>[];
      header.add(const Card(
          child: SizedBox(
              height: 60, width: 200, child: ListTile(title: Text('months')))));
      for (String id in state.users.keys) {
        header.add(
          NameUserCard(id: id, name: state.users[id] ?? ''),
        );
      }
      var rows = <Widget>[];
      var number = 0;
      var leftHeader = <Widget>[];
      for (var month in state.months) {
        var cells = <Widget>[];
        leftHeader.add(Card(
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
        number = cells.length;
        rows.add(Row(
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
              )),
        ],
      );
    })));
  }
}
