// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:electricity_counter/models/entry.dart';
import 'package:electricity_counter/services/enum.dart';
import 'package:f_logs/f_logs.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import 'package:collection/collection.dart';

class UsersRepository {
  var users = <User>[];
  UsersRepository() {
    _loadTestData();
  }

  void _loadTestData() {
    User? matejkovi = createNewUser('Matějkovi');
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 150,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.nt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.vt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 150,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.nt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.vt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 150,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.nt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.vt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 150,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.nt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.vt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 150,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.nt));
    matejkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: matejkovi.id,
        typeEntry: TypeEntry.vt));
    User? zizkovi = createNewUser('Žižkovi');
    zizkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 130,
        idUser: zizkovi.id,
        typeEntry: TypeEntry.nt));
    zizkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 30,
        idUser: zizkovi.id,
        typeEntry: TypeEntry.vt));
    User? capkovi = createNewUser('Čapkovi');
    capkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 110,
        idUser: capkovi.id,
        typeEntry: TypeEntry.nt));
    capkovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: capkovi.id,
        typeEntry: TypeEntry.vt));
    User? cincalovi = createNewUser('Činčalovi');
    cincalovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 110,
        idUser: cincalovi.id,
        typeEntry: TypeEntry.nt));
    cincalovi?.addEntry(Entry(
        date: DateTime(2022, 12, 2),
        value: 40,
        idUser: cincalovi.id,
        typeEntry: TypeEntry.vt));
  }

  User? createNewUser(String name) {
    if (users.firstWhereOrNull((element) => element.name == name) != null) {
      FLog.warning(text: 'this user name is already in use');
      return null;
    }
    var uuid = const Uuid();
    User user = User(id: uuid.v4(), name: name, listEntries: []);
    users.add(user);
    return user;
  }

  void deleteUser(String idUser) {
    users.remove(users.firstWhereOrNull((element) => element.id == idUser));
  }

  void addEntry(Entry entry) {
    if (users.isEmpty) {
      return;
    }
    for (int i = 0; i < users.length; i++) {
      if (entry.idUser == users[i].id) {
        users[i].addEntry(entry);
        return;
      }
    }
  }

  void removeEntry(Entry entry) {
    if (users.isEmpty) {
      return;
    }
    for (int i = 0; i < users.length; i++) {
      if (entry.idUser == users[i].id) {
        var user = users[i].copyWith();
        var ent =
            user.listEntries.firstWhereOrNull((element) => element == entry);
        if (ent == null) {
          FLog.error(text: 'entry is not here');
          return;
        }
        user.listEntries.remove(ent);
        users[i] = user;
        FLog.debug(text: '${users[i].listEntries.length}');
        return;
      }
    }
  }
}
