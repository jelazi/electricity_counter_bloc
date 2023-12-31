// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:electricity_counter/view/widgets/edit_dialogs/add_enter_dialog.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/question_dialog.dart';

import '../../blogs/bloc_export.dart';
import '../../models/user.dart';

class EntryCard extends StatelessWidget {
  String value;
  String idUser;
  DateTime date;
  double? nt;
  double? vt;
  EntryCard({
    Key? key,
    required this.value,
    required this.idUser,
    required this.date,
    required this.nt,
    required this.vt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    return Card(
        child: SizedBox(
      height: 60,
      width: 200,
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
              /*  items.add(getMenuItemWithIcon(context, 'view', Icons.preview, () {
                FLog.debug(text: 'preview');
              }));*/
              items.add(getMenuItemWithIcon(context, 'edit', Icons.edit, () {
                User? user = context
                    .read<UsersBloc>()
                    .usersRepository
                    .getUserById(idUser);
                if (user != null) {
                  Future.delayed(Duration.zero, () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddEnterDialog(
                            nt: nt ?? 0,
                            vt: vt ?? 0,
                            month: date,
                            user: user,
                          );
                        });
                  });
                }
              }));
              items
                  .add(getMenuItemWithIcon(context, 'delete', Icons.delete, () {
                Future.delayed(Duration.zero, () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => QuestionDialog(
                          title: '${'deleteEnter'.tr()} $value',
                          okClick: () =>
                              context.read<UsersBloc>().add(RemoveEntry(
                                    idUser: idUser,
                                    date: date,
                                  )),
                          question: '${'deleteEnterQuestion'.tr()} $value?'));
                });
              }));
            } else {
              items.add(getMenuItemWithIcon(context, 'add'.tr(), Icons.add, () {
                User? user = context
                    .read<UsersBloc>()
                    .usersRepository
                    .getUserById(idUser);
                if (user != null) {
                  Future.delayed(Duration.zero, () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddEnterDialog(month: date, user: user);
                        });
                  });
                }
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
              (text).tr(),
            ),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
