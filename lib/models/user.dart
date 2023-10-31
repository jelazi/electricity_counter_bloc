// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'entry.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
@HiveType(typeId: 1)
class User extends Equatable {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<Entry> listEntries;
  @HiveField(3)
  int order;

  @override
  List<Object?> get props => [
        id,
        name,
        listEntries,
      ];

  User({
    required this.order,
    required this.id,
    required this.name,
    required this.listEntries,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  void addEntry(Entry entry) {
    listEntries.add(entry);
  }

  User copyWith({
    String? id,
    String? name,
    List<Entry>? listEntries,
    int? order,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      listEntries: listEntries ?? this.listEntries,
      order: order ?? this.order,
    );
  }
}
