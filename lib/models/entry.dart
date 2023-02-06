// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:electricity_counter/services/enum.dart';

class Entry {
  DateTime date;
  double value;
  String idUser;
  TypeEntry typeEntry;
  Entry({
    required this.date,
    required this.value,
    required this.idUser,
    required this.typeEntry,
  });
}
