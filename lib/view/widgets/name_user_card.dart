import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/question_dialog.dart';

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
    final key = GlobalKey();
    return Card(
        color: Colors.red[50],
        child: SizedBox(
          height: 60,
          width: 200,
          child: ListTile(
            title: Text(name),
            trailing: IconButton(
              key: key,
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                RenderBox? box =
                    key.currentContext!.findRenderObject() as RenderBox?;
                final Size size = box!.size;
                Offset offset = box.localToGlobal(Offset.zero);
                var items = <PopupMenuEntry>[];
                items.add(
                    getMenuItemWithIcon(context, 'delete', Icons.delete, () {
                  Future.delayed(Duration.zero, () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => QuestionDialog(
                            title: '${'deleteUser'.tr()} $name',
                            okClick: () => context
                                .read<UsersBloc>()
                                .add(RemoveUser(id: id)),
                            question: '${'deleteUserQuestion'.tr()} $name?'));
                  });
                }));
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
              (text).tr(),
            ),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
