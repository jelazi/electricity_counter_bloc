// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_table_2/data_table_2.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../../blogs/bloc_export.dart';
import '../../../localization/app_localizations.dart';
import '../../../models/entry.dart';
import '../../../models/user.dart';

class HomePageDesktop extends StatefulWidget {
  HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      var columns = <DataColumn>[];
      columns.add(const DataColumn(label: Text('months')));
      for (String id in state.users.keys) {
        columns.add(DataColumn(
            label: NameUserCard(id: id, name: state.users[id] ?? '')));
      }
      var rows = <DataRow>[];
      for (var month in state.months) {
        var cells = <DataCell>[];
        cells.add(DataCell(Text(month)));
        for (var i = 0; i < state.entries.length; i++) {
          cells.add(DataCell(EntryCard(
            value: state.entries[i][state.months.indexOf(month)],
            idUser: state.users.keys.elementAt(i),
            date: month,
          )));
        }
        rows.add(DataRow(cells: cells));
      }
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              // color: Colors.red[50],
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 1200,
                    headingRowColor: MaterialStateProperty.all(Colors.amber),
                    columns: columns,
                    rows: rows),
              )),
        ],
      );
    })));
  }
}

class EntryCard extends StatelessWidget {
  String value;
  String idUser;
  String date;
  EntryCard({
    Key? key,
    required this.value,
    required this.idUser,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
      width: 200,
      child: ListTile(
        leading: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => context.read<UsersBloc>().add(RemoveEntry(
                idUser: idUser,
                date: date,
              )),
        ),
      ),
    ));
  }
}

class NameUserCard extends StatelessWidget {
  String name;
  String id;
  NameUserCard({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.red[50],
        child: ListTile(
          title: Text(name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<UsersBloc>().add(RemoveUser(id: id)),
          ),
        ));
  }
}
