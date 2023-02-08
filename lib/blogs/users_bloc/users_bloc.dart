// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../models/entry.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersRepository usersRepository;
  UsersBloc({
    required this.usersRepository,
  }) : super(UsersInitial(
            users: const <String, String>{},
            month: const <String>[],
            entries: const <List<String>>[])) {
    on<_CreateUsers>(_createUsers);
    on<AddUser>(_addUser);
    on<RemoveUser>(_removeUser);
    on<AddEntry>(_addEntry);
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
    ));
  }

  List _generateUserTableData() {
    final state = this.state;
    var users = usersRepository.users;
    var mapUsers = <String, String>{};
    var listMonth = <String>[];
    var entries = <List<String>>[];
    for (var user in users) {
      mapUsers[user.id] = user.name;
      for (var entry in user.listEntries) {
        String month = DateFormat('yyyy-MM').format(entry.date);
        if (!listMonth.contains(month)) {
          listMonth.add(month);
        }
      }
    }
    entries = List<List<String>>.generate(users.length,
        (index) => List<String>.generate(listMonth.length, (index) => ''));
    for (User user in users) {
      for (var month in listMonth) {
        var entry = user.listEntries.firstWhereOrNull(
            (entry) => DateFormat('yyyy-MM').format(entry.date) == month);
        if (entry == null) {
          entries[users.indexOf(user)][listMonth.indexOf(month)] = '';
        } else {
          entries[users.indexOf(user)][listMonth.indexOf(month)] =
              'nt: ${entry.nt} vt: ${entry.vt}';
        }
      }
    }
    return [mapUsers, listMonth, entries];
  }

  void _addUser(AddUser event, Emitter<UsersState> emit) {
    final state = this.state;
    usersRepository.createNewUser(event.nameUser);
    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
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
    ));
  }

  void _addEntry(AddEntry event, Emitter<UsersState> emit) {
    final state = this.state;
    Entry? entry = usersRepository.getEntry(event.idUser, event.date);
    if (entry == null) {
      return;
    }
    usersRepository.addEntry(entry);
    var list = _generateUserTableData();
    emit(state.copyWith(
      users: list[0],
      months: list[1],
      entries: list[2],
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
    ));
  }
}
