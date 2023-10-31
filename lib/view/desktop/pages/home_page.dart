// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:electricity_counter/view/desktop/areas/invoice_table_widget.dart';
import 'package:flutter/material.dart';

import '../areas/measure_table_widget.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

//test

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MeasureTableWidget(),
        InvoiceTableWidget(),
      ],
    ));
  }
}
