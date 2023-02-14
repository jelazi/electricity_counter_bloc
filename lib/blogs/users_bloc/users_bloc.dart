// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/f_logs.dart';
import 'package:intl/intl.dart';

import '../../models/entry.dart';
import '../../models/user.dart';
import '../../repositories/settings_repository.dart';
import '../../repositories/users_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersRepository usersRepository;
  SettingsRepository settingsRepository;
  var currentListEntry = <Entry>[];
  UsersBloc({
    required this.usersRepository,
    required this.settingsRepository,
  }) : super(UsersInitial(
          users: const <String, String>{},
          month: const <DateTime>[],
          entries: const <List<String>>[],
          nts: const <List<double?>>[],
          vts: const <List<double?>>[],
        )) {
    on<_CreateUsers>(_createUsers);
    on<AddUser>(_addUser);
    on<RemoveUser>(_removeUser);
    on<AddEntry>(_addEntry);
    on<AddListEntry>(_addListEntry);
    on<RemoveEntry>(_removeEntry);
    add(_CreateUsers(users: List.from(usersRepository.users)));
  }

  void _createUsers(_CreateUsers event, Emitter<UsersState> emit) {
    final state = this.state;

    var list = _generateUserTableData();

    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
      nts: list[3],
      vts: list[4],
    ));
  }

  List _generateUserTableData() {
    final state = this.state;
    var users = usersRepository.users;

    var mapUsers = <String, String>{};
    var months = <DateTime>[];
    var entries = <List<String>>[];
    var vts = <List<double?>>[];
    var nts = <List<double?>>[];
    for (var user in users) {
      mapUsers[user.id] = user.name;
      for (var entry in user.listEntries) {
        if (!months.contains(entry.date)) {
          months.add(entry.date);
        }
      }
    }
    months.sort();

    entries = List<List<String>>.generate(users.length,
        (index) => List<String>.generate(months.length, (index) => ''));
    nts = List<List<double?>>.generate(users.length,
        (index) => List<double?>.generate(months.length, (index) => null));
    vts = List<List<double?>>.generate(users.length,
        (index) => List<double?>.generate(months.length, (index) => null));
    for (User user in users) {
      for (var month in months) {
        var entry =
            user.listEntries.firstWhereOrNull((entry) => entry.date == month);
        if (entry == null) {
          entries[users.indexOf(user)][months.indexOf(month)] = '';
          vts[users.indexOf(user)][months.indexOf(month)] = null;
          nts[users.indexOf(user)][months.indexOf(month)] = null;
        } else {
          entries[users.indexOf(user)][months.indexOf(month)] =
              'nt: ${entry.nt} vt: ${entry.vt}';
          nts[users.indexOf(user)][months.indexOf(month)] = entry.nt;
          vts[users.indexOf(user)][months.indexOf(month)] = entry.vt;
        }
      }
    }
    return [
      mapUsers,
      months,
      entries,
      nts,
      vts,
    ];
  }

  void _addUser(AddUser event, Emitter<UsersState> emit) {
    final state = this.state;
    usersRepository.createNewUser(event.nameUser);

    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
      nts: list[3],
      vts: list[4],
    ));
  }

  void _removeUser(RemoveUser event, Emitter<UsersState> emit) {
    final state = this.state;
    usersRepository.deleteUser(event.id);
    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
      nts: list[3],
      vts: list[4],
    ));
  }

  void _addEntry(AddEntry event, Emitter<UsersState> emit) {
    final state = this.state;
    Entry? entry = usersRepository.getEntry(event.idUser, event.date);
    if (entry == null) {
      entry = Entry(
          date: event.date, idUser: event.idUser, nt: event.nt, vt: event.vt);
      usersRepository.addEntry(entry);
    } else {
      Entry newEntry = entry.copyWith(nt: event.nt, vt: event.vt);
      usersRepository.addEntry(newEntry);
    }

    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
      nts: list[3],
      vts: list[4],
    ));
  }

  void _addListEntry(AddListEntry event, Emitter<UsersState> emit) {
    final state = this.state;
    final entries = event.entries;
    NumberFormat formatter = NumberFormat("00");
    for (var i = 0; i < entries[0].length; i++) {
      var user = usersRepository.getUserByName(entries[0][i]);
      FLog.debug(text: '${user?.name}');
      if (user != null) {
        usersRepository.addEntry(Entry(
            date: DateTime.parse(
                '${event.year}-${formatter.format(event.month)}-01'),
            idUser: user.id,
            nt: double.parse(entries[1][i]),
            vt: double.parse(entries[2][i])));
      }
    }
    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
      nts: list[3],
      vts: list[4],
    ));
  }

  void _removeEntry(RemoveEntry event, Emitter<UsersState> emit) {
    final state = this.state;
    Entry? entry = usersRepository.getEntry(event.idUser, event.date);
    if (entry == null) {
      return;
    }
    usersRepository.removeEntry(entry);
    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
      nts: list[3],
      vts: list[4],
    ));
  }

  Map<String, String> getCurrentUsers() {
    return state.users;
  }
}
