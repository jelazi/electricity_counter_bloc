import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/blogs/bloc_export.dart';
import 'package:flutter/material.dart';

import 'invoices_page.dart';
import 'measure_page.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page '),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'measurePage'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: 'invoicesPage'.tr(),
            ),
          ]),
      body: _selectedIndex == 0 ? MeasurePage() : InvoicesPage(),
    );
  }
}
