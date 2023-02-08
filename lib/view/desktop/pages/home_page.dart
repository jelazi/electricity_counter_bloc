// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_table_2/data_table_2.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../../blogs/bloc_export.dart';
import '../../../localization/app_localizations.dart';
import '../../../models/entry.dart';
import '../../../models/user.dart';
import './data_sources.dart';
import './nav_helper.dart';

class HomePageDesktop extends StatefulWidget {
  HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  ScrollController controller = ScrollController();
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late DessertDataSource _dessertsDataSource;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final currentRouteOption = getCurrentRouteOption(context);
      _dessertsDataSource = DessertDataSource(
          context,
          false,
          currentRouteOption == rowTaps,
          currentRouteOption == rowHeightOverrides,
          currentRouteOption == showBordersWithZebraStripes);
      // Default sorting sample. Set __sortColumnIndex to 0 and uncoment the lines below
      // if (_sortColumnIndex == 0) {
      //   _sort<String>((d) => d.name, _sortColumnIndex!, _sortAscending);
      // }
      _initialized = true;
      _dessertsDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Dessert d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _dessertsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      final users = List.from(state.users);
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              color: Colors.blue[50],
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  border: getCurrentRouteOption(context) == fixedColumnWidth
                      ? TableBorder(
                          top: const BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.grey[300]!),
                          left: BorderSide(color: Colors.grey[300]!),
                          right: BorderSide(color: Colors.grey[300]!),
                          verticalInside: BorderSide(color: Colors.grey[300]!),
                          horizontalInside:
                              const BorderSide(color: Colors.grey, width: 1))
                      : (getCurrentRouteOption(context) ==
                              showBordersWithZebraStripes
                          ? TableBorder.all()
                          : null),
                  dividerThickness:
                      1, // this one will be ignored if [border] is set above
                  bottomMargin: 10,
                  minWidth: 900,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
                  sortArrowAnimationDuration: const Duration(
                      milliseconds: 500), // custom animation duration
                  onSelectAll: (val) =>
                      setState(() => _dessertsDataSource.selectAll(val)),
                  columns: [
                    DataColumn2(
                      label: const Text('Desert'),
                      size: ColumnSize.S,
                      // example of fixed 1st row
                      fixedWidth:
                          getCurrentRouteOption(context) == fixedColumnWidth
                              ? 200
                              : null,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.name, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Calories'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.calories, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Fat (gm)'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.fat, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Carbs (gm)'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.carbs, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Protein (gm)'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.protein, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Sodium (mg)'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.sodium, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Calcium (%)'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.calcium, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Iron (%)'),
                      size: ColumnSize.S,
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.iron, columnIndex, ascending),
                    ),
                  ],
                  empty: Center(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: const Text('No data'))),
                  rows: getCurrentRouteOption(context) == noData
                      ? []
                      : List<DataRow>.generate(_dessertsDataSource.rowCount,
                          (index) => _dessertsDataSource.getRow(index)),
                ),
              )),
        ],
      );
    })));
  }
}

class EntryCard extends StatelessWidget {
  Entry entry;
  EntryCard({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Text(entry.value.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () =>
            context.read<UsersBloc>().add(RemoveEntry(entry: entry)),
      ),
    ));
  }
}

class NameUserCard extends StatelessWidget {
  User user;
  NameUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.red[50],
        child: ListTile(
          title: Text(user.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                context.read<UsersBloc>().add(RemoveUser(user: user)),
          ),
        ));
  }
}
