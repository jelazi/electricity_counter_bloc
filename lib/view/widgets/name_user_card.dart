import 'package:flutter/material.dart';

import '../../blogs/bloc_export.dart';

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
