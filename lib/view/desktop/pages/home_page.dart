// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      final users = List.from(state.users);
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.blue[50],
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [
                Text(AppLocalizations.of(context).translate('users')),
                Expanded(
                  child: RawScrollbar(
                    radius: Radius.circular(8),
                    thickness: 10,
                    thumbVisibility: true,
                    controller: controller,
                    child: ListView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: users.map((user) {
                          var list = <Widget>[];
                          list.add(NameUserCard(user: user));
                          for (var entry in user.listEntries) {
                            list.add(EntryCard(entry: entry));
                          }
                          return SizedBox(
                            width: 400,
                            child: ListView(
                              controller:
                                  state.controllers[state.users.indexOf(user)],
                              children: list,
                            ),
                          );
                        }).toList()),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
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
