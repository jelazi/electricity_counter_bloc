// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:electricity_counter/models/entry.dart';
import 'package:electricity_counter/repositories/settings_repository.dart';

import 'package:uuid/uuid.dart';

import '../models/user.dart';
import 'package:collection/collection.dart';

class UsersRepository {
  final _users = <User>[];
  SettingsRepository settingsRepository;
  final _errorMessageController = StreamController<String>();
  Stream<String> get errorMessage => _errorMessageController.stream;
  int lastOrder = 0;

  UsersRepository({
    required this.settingsRepository,
  });

  List<User> get users {
    _users.sort((a, b) => a.order.compareTo(b.order));
    return _users;
  }

  Future<void> initListUsers() async {
    List<User> user = await settingsRepository.getListUserFromLocal();

    for (var user in _users) {
      lastOrder++;
      user.order = lastOrder;

      if (user.order > lastOrder) {
        lastOrder = user.order;
      }
    }
    // _users = user;
    await updateListUsersFromFirebase();
  }

  Future<void> updateListUsersFromFirebase() async {
    List<User> firebaseList = await settingsRepository.getListUserFromFirebase();
    for (var i = 0; i < _users.length; i++) {
      for (var user in firebaseList) {
        if (_users[i].id == user.id && _users[i] != user) {
          _users[i] = user;
        }
      }
    }
    for (var user in firebaseList) {
      if (_users.firstWhereOrNull((element) => element.id == user.id) == null) {
        _users.add(user);
        if (user.order > lastOrder) {
          lastOrder = user.order;
        }
      }
    }
  }

  User? getUserById(String id) {
    return _users.firstWhereOrNull((element) => element.id == id);
  }

  User? getUserByName(String name) {
    return _users.firstWhereOrNull((element) => element.name == name);
  }

  List<Entry> getListEntriesByDate(DateTime date) {
    var list = <Entry>[];
    for (var user in _users) {
      for (var entry in user.listEntries) {
        if (entry.date.year == date.year && entry.date.month == date.month) {
          list.add(entry);
        }
      }
    }
    return list;
  }

  Entry? getEntry(String idUser, DateTime date) {
    for (var user in _users) {
      if (user.id == idUser) {
        for (var entry in user.listEntries) {
          if (entry.date.month == date.month && entry.date.year == date.year) {
            return entry;
          }
        }
      }
    }
    return null;
  }

  User? createNewUser(String name) {
    if (_users.firstWhereOrNull((element) => element.name == name) != null) {
      print('this user name is already in use');
      _errorMessageController.add(('userExists').tr());
      return null;
    }
    var uuid = const Uuid();
    lastOrder++;
    User user = User(id: uuid.v4(), name: name, listEntries: const [], order: lastOrder);
    _users.add(user);
    settingsRepository.saveUser(user);

    return user;
  }

  void deleteUser(String idUser) {
    User? user = getUserById(idUser);
    if (user != null) {
      settingsRepository.removeUser(user);
      _users.remove(_users.firstWhereOrNull((element) => element.id == idUser));
    }
  }

  void addEntry(Entry entry) {
    if (_users.isEmpty) {
      return;
    }
    for (int i = 0; i < _users.length; i++) {
      if (entry.idUser == _users[i].id) {
        int month = entry.date.month;
        int year = entry.date.year;
        var updateEntry = _users[i].listEntries.firstWhereOrNull((element) => element.date.month == month && element.date.year == year);
        if (updateEntry != null) {
          print('update entry');
          _users[i].listEntries[_users[i].listEntries.indexOf(updateEntry)].nt = entry.nt;
          _users[i].listEntries[_users[i].listEntries.indexOf(updateEntry)].vt = entry.vt;
          settingsRepository.saveUser(_users[i]);
          return;
        }
        _users[i].addEntry(entry);
        settingsRepository.saveUser(_users[i]);
        return;
      }
    }
  }

  void changeSortByListNames(List<String> newListName) {
    var index = 0;
    for (final name in newListName) {
      index++;
      for (int i = 0; i < _users.length; i++) {
        if (name == _users[i].name && _users[i].order != index) {
          _users[i].order = index;
          settingsRepository.saveUser(_users[i]);
        }
      }
    }
  }

  void removeEntry(Entry entry) {
    if (_users.isEmpty) {
      return;
    }
    for (int i = 0; i < _users.length; i++) {
      if (entry.idUser == _users[i].id) {
        var user = _users[i].copyWith();
        var ent = user.listEntries.firstWhereOrNull((element) => element == entry);
        if (ent == null) {
          print('entry is not here');
          return;
        }
        user.listEntries.remove(ent);
        _users[i] = user;
        settingsRepository.saveUser(_users[i]);
        print('${_users[i].listEntries.length}');
        return;
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
}
