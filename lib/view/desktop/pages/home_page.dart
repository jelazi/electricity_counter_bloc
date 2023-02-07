// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import '../../../blogs/bloc_export.dart';
import '../../../localization/app_localizations.dart';
import '../../../models/entry.dart';
import '../../../models/user.dart';

class HomePageDesktop extends StatelessWidget {
  HomePageDesktop({Key? key}) : super(key: key);
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      final users = List.from(state.users);
      var max = 0;
      users.forEach((user) {
        if (user.listEntries.length > max) {
          max = user.listEntries.length;
        }
      });
      return Column(children: [
        Text(AppLocalizations.of(context).translate('usersList')),
        Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(200),
              children: state.users.map((user) {
                TableCell cellName = TableCell(child: NameUserCard(user: user));
                var entries = <TableCell>[];
                entries.add(cellName);
                for (var i = 0; i < max; i++) {
                  if (user.listEntries.length > i) {
                    entries.add(TableCell(
                        child: EntryCard(
                      entry: user.listEntries[i],
                    )));
                  } else {
                    entries.add(TableCell(child: Container()));
                  }
                }
                return TableRow(children: entries);
              }).toList(),
            ))
      ]);
    })));
  }
}

class EntryCard extends StatelessWidget {
  Entry entry;
  EntryCard({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Text(entry.value.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () =>
            context.read<UsersBloc>().add(RemoveEntry(entry: entry)),
      ),
    ));
  }
}

class NameUserCard extends StatelessWidget {
  User user;
  NameUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.red[50],
        child: ListTile(
          title: Text(user.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                context.read<UsersBloc>().add(RemoveUser(user: user)),
          ),
        ));
  }
}
