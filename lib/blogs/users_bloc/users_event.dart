part of 'users_bloc.dart';

class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class _CreateUsers extends UsersEvent {
  List<User> users;
  _CreateUsers({required this.users});

  @override
  List<Object> get props => [users];
}

class AddUser extends UsersEvent {
  String nameUser;
  AddUser({required this.nameUser});

  @override
  List<Object> get props => [nameUser];
}

class RemoveUser extends UsersEvent {
  User user;
  RemoveUser({required this.user});

  @override
  List<Object> get props => [user];
}

class AddEntry extends UsersEvent {
  Entry entry;
  AddEntry({required this.entry});

  @override
  List<Object> get props => [entry];
}

class RemoveEntry extends UsersEvent {
  Entry entry;
  RemoveEntry({required this.entry});

  @override
  List<Object> get props => [entry];
}
