// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:electricity_counter/services/enum.dart';

part 'entry.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
@HiveType(typeId: 0)
class Entry {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String idUser;
  @HiveField(2)
  double nt;
  @HiveField(3)
  double vt;

  Entry({
    required this.date,
    required this.idUser,
    required this.nt,
    required this.vt,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryToJson(this);

  Entry copyWith({
    DateTime? date,
    String? idUser,
    double? nt,
    double? vt,
  }) {
    return Entry(
      date: date ?? this.date,
      idUser: idUser ?? this.idUser,
      nt: nt ?? this.nt,
      vt: vt ?? this.vt,
    );
  }
}
