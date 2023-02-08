// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'entry.dart';

class User {
  late String id;
  String name;
  List<Entry> listEntries;

  User({
    required this.id,
    required this.name,
    required this.listEntries,
  });

  void addEntry(Entry entry) {
    listEntries.add(entry);
  }

  User copyWith({
    String? id,
    String? name,
    List<Entry>? listEntries,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      listEntries: listEntries ?? this.listEntries,
    );
  }
}
