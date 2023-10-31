import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/question_dialog.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';

class ReorderableViewPage extends StatefulWidget {
  List<String> usersName = [];
  List<User> users = [];

  ReorderableViewPage({super.key});
  @override
  _ReorderableViewPageState createState() => _ReorderableViewPageState();
}

class _ReorderableViewPageState extends State<ReorderableViewPage> {
  @override
  void initState() {
    widget.users = context.read<UsersBloc>().usersRepository.users;
    for (var user in widget.users) {
      widget.usersName.add(user.name);
    }
    super.initState();
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = widget.usersName.removeAt(oldindex);
      widget.usersName.insert(newindex, items);
    });
  }

  void sorting() {
    setState(() {
      widget.usersName.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return QuestionDialog(
                    okClick: () {
                      context.read<UsersBloc>().add(ChangeOrderUsers(nameOrder: widget.usersName));
                      Navigator.of(context).pop();
                    },
                    cancelClick: () {
                      Navigator.of(context).pop();
                    },
                    question: 'saveChangeQuestion'.tr(),
                    title: 'change'.tr(),
                  );
                });
          },
          icon: const Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        title: Text(
          'sortUsers'.tr(),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.sort_by_alpha), tooltip: 'sortByAlpha'.tr(), onPressed: sorting),
        ],
      ),
      body: ReorderableListView(
        onReorder: reorderData,
        children: [
          for (final items in widget.usersName)
            Card(
              color: Colors.blueGrey,
              key: ValueKey(items),
              elevation: 2,
              child: ListTile(
                title: Text(items, style: const TextStyle(color: Colors.white)),
                leading: const Icon(
                  Icons.work,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
