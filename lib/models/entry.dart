// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:electricity_counter/services/enum.dart';

class Entry {
  DateTime date;
  String idUser;
  double nt;
  double vt;

  Entry({
    required this.date,
    required this.idUser,
    required this.nt,
    required this.vt,
  });
}
