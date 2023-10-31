// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/edit_dialog.dart';

import 'package:flutter/material.dart';

class SelectDateDialog extends StatefulWidget {
  String title;
  Function okClick;
  var listMonths = <String>[];
  var listYears = <String>[];
  var selectedMonth = '';
  var selectedYear = '';
  SelectDateDialog({
    Key? key,
    required this.title,
    required this.okClick,
  }) : super(key: key) {
    listMonths = [
      ('january').tr(),
      ('february').tr(),
      ('march').tr(),
      ('april').tr(),
      ('mai').tr(),
      ('june').tr(),
      ('july').tr(),
      ('august').tr(),
      ('september').tr(),
      ('october').tr(),
      ('november').tr(),
      ('december').tr(),
    ];
    var currentYear = DateTime.now().year;
    var currentMonth = DateTime.now().month;
    listYears =
        List.generate(10, (index) => (currentYear - 2 + index).toString());
    selectedYear = currentYear.toString();
    selectedMonth = listMonths[currentMonth - 1].toString();
  }

  @override
  State<SelectDateDialog> createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDateDialog> {
  @override
  Widget build(BuildContext context) {
    return EditDialog(
        okBack: false,
        title: widget.title,
        okClick: () {
          var date = DateTime(int.parse(widget.selectedYear),
              widget.listMonths.indexOf(widget.selectedMonth) + 1);
          var invoice = context
              .read<InvoicesBloc>()
              .invoicesRepository
              .getInvoiceByDate(date);
          var listEntry = context
              .read<UsersBloc>()
              .usersRepository
              .getListEntriesByDate(date);
          if (invoice != null) {
            if (listEntry.isNotEmpty) {
              context.read<InvoicesBloc>().currentInvoice = invoice;
              context.read<UsersBloc>().currentListEntry = listEntry;
              widget.okClick(
                invoice,
                listEntry,
              );
            } else {
              print('there is not entries');
              context
                  .read<NotificationBloc>()
                  .add(CreateMessage(message: ('noEntriesThisDate'.tr())));
            }
          } else {
            print('something problem');
            context
                .read<NotificationBloc>()
                .add(CreateMessage(message: ('noCorrectDateInvoice'.tr())));
          }
        },
        width: MediaQuery.of(context).size.width * 0.5,
        widgetContent: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(('month').tr()),
                SizedBox(
                  width: 100,
                  child: DropdownButton(
                    items: widget.listMonths
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      print('value: $value');
                      setState(() {
                        widget.selectedMonth = value as String? ?? 'Leden';
                      });
                    },
                    value: widget.selectedMonth,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(('year').tr()),
                SizedBox(
                  width: 100,
                  child: DropdownButton(
                    items: widget.listYears
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      print('value: $value');
                      setState(() {
                        widget.selectedYear =
                            value as String? ?? widget.selectedYear;
                      });
                    },
                    value: widget.selectedYear,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
