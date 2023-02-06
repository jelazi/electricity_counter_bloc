import 'package:flutter/material.dart';

import '../../../blogs/bloc_export.dart';
import '../../../localization/app_localizations.dart';

class HomePageDesktop extends StatelessWidget {
  HomePageDesktop({Key? key}) : super(key: key);
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      return Column(
        children: [
          Text(AppLocalizations.of(context).translate('usersList')),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              thickness: 10,
              child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: state.users
                      .map((user) => SizedBox(
                            width: 400,
                            child: Column(
                              children: [
                                Card(
                                    color: Colors.red[50],
                                    child: ListTile(
                                      title: Text(user.name),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => context
                                            .read<UsersBloc>()
                                            .add(RemoveUser(user: user)),
                                      ),
                                    )),
                                Expanded(
                                  child: ListView(
                                    children: user.listEntries
                                        .map((entry) => Card(
                                                child: ListTile(
                                              leading:
                                                  Text(entry.value.toString()),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () => context
                                                    .read<UsersBloc>()
                                                    .add(RemoveEntry(
                                                        entry: entry)),
                                              ),
                                            )))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList()),
            ),
          ),
        ],
      );
    })));
  }
}
