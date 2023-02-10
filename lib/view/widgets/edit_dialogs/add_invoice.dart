// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/blogs/notification_bloc/notification_bloc.dart';
import 'package:electricity_counter/view/widgets/edit_dialogs/edit_dialog.dart';

import '../../../localization/app_localizations.dart';
import '../../../models/invoice.dart';

class AddInvoiceDialog extends StatefulWidget {
  String title;
  Function okClick;
  BuildContext context;
  var listMonths = <String>[];
  var listYears = <String>[];
  var selectedMonth = '';
  var selectedYear = '';

  AddInvoiceDialog({
    Key? key,
    required this.title,
    required this.okClick,
    required this.context,
  }) : super(key: key) {
    listMonths = [
      AppLocalizations.of(context).translate('january'),
      AppLocalizations.of(context).translate('february'),
      AppLocalizations.of(context).translate('march'),
      AppLocalizations.of(context).translate('april'),
      AppLocalizations.of(context).translate('mai'),
      AppLocalizations.of(context).translate('june'),
      AppLocalizations.of(context).translate('july'),
      AppLocalizations.of(context).translate('august'),
      AppLocalizations.of(context).translate('september'),
      AppLocalizations.of(context).translate('october'),
      AppLocalizations.of(context).translate('november'),
      AppLocalizations.of(context).translate('december'),
    ];
    var currentYear = DateTime.now().year;
    var currentMonth = DateTime.now().month;
    listYears =
        List.generate(10, (index) => (currentYear - 2 + index).toString());
    selectedYear = currentYear.toString();
    selectedMonth = listMonths[currentMonth - 1].toString();
  }

  @override
  State<AddInvoiceDialog> createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<AddInvoiceDialog> {
  TextEditingController fixController = TextEditingController();
  TextEditingController ntController = TextEditingController();
  TextEditingController vtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    int index = -1;
    return EditDialog(
      okBack: false,
      okClick: () {
        List errors = checkInputs();
        if (errors.isNotEmpty) {
          context.read<NotificationBloc>().add(
              CreateMessage(message: 'Prázdná data: ${errors.join(", ")}'));
        } else {
          context.read<InvoicesBloc>().add(NewInvoice(
                month: widget.listMonths.indexOf(widget.selectedMonth) + 1,
                year: int.parse(widget.selectedYear),
                fixRate: double.parse(fixController.text),
                floatingNt: double.parse(ntController.text),
                floatingVT: double.parse(vtController.text),
              ));
          Navigator.of(context).pop();
        }
      },
      title: widget.title,
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.6,
      widgetContent: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(AppLocalizations.of(context).translate('month')),
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
                        FLog.debug(text: 'value: $value');
                        setState(() {
                          widget.selectedMonth = value ?? widget.selectedMonth;
                        });
                      },
                      value: widget.selectedMonth,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context).translate('year')),
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
                        FLog.debug(text: 'value: $value');
                        setState(() {
                          widget.selectedYear = value ?? widget.selectedYear;
                        });
                      },
                      value: widget.selectedYear,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${AppLocalizations.of(context).translate('fixRate')}: '),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ],
                            controller: fixController,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${AppLocalizations.of(context).translate('floatingRateNT')}: '),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ],
                            controller: ntController,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${AppLocalizations.of(context).translate('floatingRateVT')}: '),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ],
                            controller: vtController,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  List checkInputs() {
    var list = [];
    if (ntController.text.isEmpty) {
      list.add(AppLocalizations.of(context).translate('floatingRateNT'));
    }
    if (vtController.text.isEmpty) {
      list.add(AppLocalizations.of(context).translate('floatingRateVT'));
    }
    if (fixController.text.isEmpty) {
      list.add(AppLocalizations.of(context).translate('fixRate'));
    }
    return list;
  }
}
