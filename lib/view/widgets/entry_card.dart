import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import '../../blogs/bloc_export.dart';
import '../../localization/app_localizations.dart';

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
    final key = GlobalKey();
    return Card(
        child: SizedBox(
      width: 250,
      child: ListTile(
        leading: Text(value),
        trailing: IconButton(
          key: key,
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            RenderBox? box =
                key.currentContext!.findRenderObject() as RenderBox?;
            final Size size = box!.size;
            Offset offset = box.localToGlobal(Offset.zero);
            var items = <PopupMenuEntry>[];
            if (value.isNotEmpty) {
              items.add(getMenuItemWithIcon(context, 'view', Icons.preview, () {
                FLog.debug(text: 'preview');
              }));
              items.add(getMenuItemWithIcon(context, 'edit', Icons.edit, () {
                FLog.debug(text: 'edit');
              }));
              items
                  .add(getMenuItemWithIcon(context, 'delete', Icons.delete, () {
                context.read<UsersBloc>().add(RemoveEntry(
                      idUser: idUser,
                      date: date,
                    ));
              }));
            } else {
              items.add(getMenuItemWithIcon(context, 'add', Icons.add, () {
                FLog.debug(text: 'add');
              }));
            }
            showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + size.height,
                    offset.dx + size.width,
                    offset.dy + size.height),
                items: items);
          },
        ),
      ),
    ));
  }

  PopupMenuItem<int> getMenuItemWithIcon(
      BuildContext context, String text, IconData iconData, Function onTap) {
    return PopupMenuItem<int>(
      value: 0,
      child: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              iconData,
              color: Colors.blue,
            ),
            Text(
              AppLocalizations.of(context).translate(text),
            ),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
