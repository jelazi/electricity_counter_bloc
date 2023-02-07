// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../models/entry.dart';
import '../../models/user.dart';
import '../../repositories/users_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersRepository usersRepository;
  UsersBloc({
    required this.usersRepository,
  }) : super(UsersInitial(
            users: const <User>[],
            controllers: const <ScrollController>[],
            controllerGroup: LinkedScrollControllerGroup())) {
    on<_CreateUsers>(_createUsers);
    on<AddUser>(_addUser);
    on<RemoveUser>(_removeUser);
    on<AddEntry>(_addEntry);
    on<RemoveEntry>(_removeEntry);
    add(_CreateUsers(users: List.from(usersRepository.users)));
  }

  void _createUsers(_CreateUsers event, Emitter<UsersState> emit) {
    final state = this.state;
    var controllers = <ScrollController>[];
    var controllerGroup = LinkedScrollControllerGroup();
    for (var user in event.users) {
      ScrollController controller = ScrollController();
      controller = controllerGroup.addAndGet();
      controllers.add(controller);
    }
    emit(state.copyWith(
      users: event.users,
      controllers: controllers,
      controllerGroup: controllerGroup,
    ));
  }

  void _addUser(AddUser event, Emitter<UsersState> emit) {
    final state = this.state;
    var user = usersRepository.createNewUser(event.nameUser);
    if (user != null) {
      var controllers = <ScrollController>[];
      var controllerGroup = LinkedScrollControllerGroup();
      for (var user in usersRepository.users) {
        ScrollController controller = ScrollController();
        controller = controllerGroup.addAndGet();
        controllers.add(controller);
      }
      emit(state.copyWith(
          users: List.from(usersRepository.users),
          controllers: controllers,
          controllerGroup: controllerGroup));
    } else {
      FLog.warning(text: 'user name is already in use');
    }
  }

  void _removeUser(RemoveUser event, Emitter<UsersState> emit) {
    final state = this.state;
    usersRepository.deleteUser(event.user.id);
    var controllers = <ScrollController>[];
    var controllerGroup = LinkedScrollControllerGroup();
    for (var user in usersRepository.users) {
      ScrollController controller = ScrollController();
      controller = controllerGroup.addAndGet();
      controllers.add(controller);
    }
    var users = List<User>.from(usersRepository.users);
    emit(state.copyWith(
      users: users,
      controllers: controllers,
      controllerGroup: controllerGroup,
    ));
  }

  void _addEntry(AddEntry event, Emitter<UsersState> emit) {
    final state = this.state;
    usersRepository.addEntry(event.entry);

    emit(state.copyWith(
      users: List.from(
        usersRepository.users,
      ),
    ));
  }

  void _removeEntry(RemoveEntry event, Emitter<UsersState> emit) {
    final state = this.state;
    usersRepository.removeEntry(event.entry);

    var users = List<User>.from(usersRepository.users);

    FLog.debug(text: '${users == state.users}');

    emit(UsersState(
      users: users,
      controllers: state.controllers,
      controllerGroup: state.controllerGroup,
    ));
  }
}
