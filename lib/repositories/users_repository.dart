// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:electricity_counter/models/entry.dart';
import 'package:electricity_counter/services/enum.dart';
import 'package:f_logs/f_logs.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import 'package:collection/collection.dart';

class UsersRepository {
  var users = <User>[];
  UsersRepository() {
    _loadTestData();
  }

  User? getUserById(String id) {
    return users.firstWhereOrNull((element) => element.id == id);
  }

  Entry? getEntry(String idUser, String date) {
    for (var user in users) {
      if (user.id == idUser) {
        for (var entry in user.listEntries) {
          if (DateFormat('d. MMMM yyyy', 'cs').format(entry.date) == date) {
            return entry;
          }
        }
      }
    }
  }

  void _loadTestData() {
    User? matejkovi = createNewUser('Matějkovi');
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 12, 2),
      vt: 40,
      nt: 150,
      idUser: matejkovi.id,
    ));
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 11, 2),
      vt: 40,
      nt: 120,
      idUser: matejkovi.id,
    ));
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 10, 2),
      vt: 30,
      nt: 110,
      idUser: matejkovi.id,
    ));
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 9, 2),
      vt: 20,
      nt: 105,
      idUser: matejkovi.id,
    ));
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 8, 2),
      vt: 30,
      nt: 100,
      idUser: matejkovi.id,
    ));
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 7, 2),
      vt: 20,
      nt: 100,
      idUser: matejkovi.id,
    ));
    matejkovi?.addEntry(Entry(
      date: DateTime(2022, 6, 2),
      vt: 10,
      nt: 140,
      idUser: matejkovi.id,
    ));

    User? zizkovi = createNewUser('Žižkovi');
    zizkovi?.addEntry(Entry(
      date: DateTime(2022, 12, 2),
      vt: 30,
      nt: 160,
      idUser: zizkovi.id,
    ));
    zizkovi?.addEntry(Entry(
      date: DateTime(2022, 5, 2),
      vt: 20,
      nt: 190,
      idUser: zizkovi.id,
    ));
    zizkovi?.addEntry(Entry(
      date: DateTime(2022, 10, 2),
      vt: 20,
      nt: 150,
      idUser: zizkovi.id,
    ));

    User? capkovi = createNewUser('Čapkovi');
    capkovi?.addEntry(Entry(
      date: DateTime(2022, 12, 2),
      vt: 50,
      nt: 150,
      idUser: capkovi.id,
    ));
    capkovi?.addEntry(Entry(
      date: DateTime(2022, 11, 2),
      vt: 30,
      nt: 130,
      idUser: capkovi.id,
    ));
    capkovi?.addEntry(Entry(
      date: DateTime(2022, 10, 2),
      vt: 10,
      nt: 100,
      idUser: capkovi.id,
    ));
    User? cincalovi = createNewUser('Činčalovi');
    cincalovi?.addEntry(Entry(
      date: DateTime(2022, 12, 2),
      vt: 40,
      nt: 150,
      idUser: cincalovi.id,
    ));
    cincalovi?.addEntry(Entry(
      date: DateTime(2022, 11, 2),
      vt: 70,
      nt: 130,
      idUser: cincalovi.id,
    ));
    cincalovi?.addEntry(Entry(
      date: DateTime(2022, 10, 2),
      vt: 40,
      nt: 150,
      idUser: cincalovi.id,
    ));
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
