// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

class UsersState extends Equatable {
  List<User> users;
  List<ScrollController> controllers;
  LinkedScrollControllerGroup controllerGroup;
  UsersState({
    required this.users,
    required this.controllers,
    required this.controllerGroup,
  });

  @override
  List<Object> get props => [users];

  UsersState copyWith({
    List<User>? users,
    List<ScrollController>? controllers,
    LinkedScrollControllerGroup? controllerGroup,
  }) {
    return UsersState(
      users: users ?? this.users,
      controllers: controllers ?? this.controllers,
      controllerGroup: controllerGroup ?? this.controllerGroup,
    );
  }
}

class UsersInitial extends UsersState {
  UsersInitial({users, controllers, controllerGroup})
      : super(
            users: users,
            controllers: controllers,
            controllerGroup: controllerGroup);
}
