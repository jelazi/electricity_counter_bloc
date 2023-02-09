// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:electricity_counter/blogs/notification_bloc/notification_bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

import 'package:electricity_counter/view/widgets/edit_dialogs/edit_dialog.dart';
import 'package:flutter/services.dart';

import '../../../Localization/app_localizations.dart';

class AddMeasurementDialog extends StatefulWidget {
  String title;
  String cancelLabel;
  String okLabel;
  Map<String, String> users;
  Function okClick;
  String month;
  String year;
  final ntEditingControllers = <TextEditingController>[];
  final vtEditingControllers = <TextEditingController>[];
  var listMonths = [
    'Leden',
    'Únor',
    'Březen',
    'Duben',
    'Květen',
    'Červen',
    'Červenec',
    'Srpen',
    'Září',
    'Říjen',
    'Listopad',
    'Prosinec',
  ];
  var listYears = <String>[];
  var selectedMonth = '';
  var selectedYear = '';

  AddMeasurementDialog({
    Key? key,
    required this.title,
    required this.cancelLabel,
    required this.okLabel,
    required this.users,
    required this.okClick,
    required this.month,
    required this.year,
  }) : super(key: key) {
    for (var user in users.entries) {
      TextEditingController ntController = TextEditingController();
      TextEditingController vtController = TextEditingController();
      ntEditingControllers.add(ntController);
      vtEditingControllers.add(vtController);
    }
    var currentYear = DateTime.now().year;
    var currentMonth = DateTime.now().month;
    listYears =
        List.generate(10, (index) => (currentYear - 2 + index).toString());
    selectedYear = currentYear.toString();
    selectedMonth = listMonths[currentMonth - 1].toString();
  }

  @override
  State<AddMeasurementDialog> createState() => _AddMeasurementDialogState();
}

class _AddMeasurementDialogState extends State<AddMeasurementDialog> {
  @override
  Widget build(BuildContext context) {
    int index = -1;
    return EditDialog(
      okBack: false,
      cancelLabel: widget.cancelLabel,
      okClick: () {
        List errors = <String>[];
        List list = checkInputs();
        var index = 0;
        for (int state in list[0]) {
          if (state == -1) {
            errors.add('${widget.users.values.toList()[index]} NT');
          }
          index++;
        }
        index = 0;
        for (int state in list[1]) {
          if (state == -1) {
            errors.add('${widget.users.values.toList()[index]} VT');
          }
          index++;
        }
        if (errors.isNotEmpty) {
          context.read<NotificationBloc>().add(
              CreateMessage(message: 'Prázdná data: ${errors.join(", ")}'));
        } else {
          var list = <List<String>>[];
          list.add(widget.users.values.toList());
          var ntList = <String>[];
          var vtList = <String>[];
          for (var ntController in widget.ntEditingControllers) {
            ntList.add(ntController.text);
          }
          list.add(ntList);
          for (var vtController in widget.vtEditingControllers) {
            vtList.add(vtController.text);
          }
          list.add(vtList);
          context.read<UsersBloc>().add(AddListEntry(
              entries: list,
              month: widget.listMonths.indexOf(widget.selectedMonth) + 1,
              year: int.parse(widget.selectedYear)));
          Navigator.of(context).pop();
        }
      },
      okLabel: widget.okLabel,
      title: widget.title,
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.6,
      widgetContent: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text('Měsíc: '),
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
                            widget.selectedMonth = value ?? 'Leden';
                          });
                        },
                        value: widget.selectedMonth,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('Rok: '),
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
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.40,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: widget.users.entries.map((entry) {
                    index++;
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.value,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'NT: ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                  controller:
                                      widget.ntEditingControllers[index],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('kVh'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                'VT: ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                  controller:
                                      widget.vtEditingControllers[index],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('kVh'),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List checkInputs() {
    var list = [
      List.generate(widget.ntEditingControllers.length, (index) => 0),
      List.generate(widget.vtEditingControllers.length, (index) => 0)
    ];
    for (var ntController in widget.ntEditingControllers) {
      if (ntController.text.isEmpty) {
        list[0][widget.ntEditingControllers.indexOf(ntController)] = -1;
      }
    }
    for (var vtController in widget.vtEditingControllers) {
      if (vtController.text.isEmpty) {
        list[1][widget.vtEditingControllers.indexOf(vtController)] = -1;
      }
    }
    return list;
  }
}
