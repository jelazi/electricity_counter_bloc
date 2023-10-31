import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../blogs/bloc_export.dart';
import '../../models/invoice.dart';
import 'edit_dialogs/question_dialog.dart';

class InvoiceCard extends StatelessWidget {
  final String text;
  final String idInvoice;

  const InvoiceCard({
    super.key,
    required this.text,
    required this.idInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    return Card(
        child: SizedBox(
            width: 210,
            child: ListTile(
              title: Text(text),
              trailing: IconButton(
                key: key,
                icon: const Icon(
                  Icons.more_vert,
                ),
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
                              title: '${'deleteInvoice'.tr()} $text',
                              okClick: () {
                                Invoice? invoice = context
                                    .read<InvoicesBloc>()
                                    .invoicesRepository
                                    .getInvoiceById(idInvoice);
                                if (invoice != null) {
                                  context
                                      .read<InvoicesBloc>()
                                      .add(DeleteInvoice(invoice: invoice));
                                } else {
                                  context.read<NotificationBloc>().add(
                                      CreateMessage(
                                          message: 'noInvoiceFound'.tr()));
                                }
                              },
                              question:
                                  '${'deleteInvoiceQuestion'.tr()} $text?'));
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
            )));
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
