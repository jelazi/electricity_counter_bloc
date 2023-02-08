// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  String id;
  RemoveUser({required this.id});

  @override
  List<Object> get props => [id];
}

class AddEntry extends UsersEvent {
  String idUser;
  String date;
  String value;
  AddEntry({
    required this.idUser,
    required this.date,
    required this.value,
  });

  @override
  List<Object> get props => [idUser, date, value];
}

class RemoveEntry extends UsersEvent {
  String idUser;
  String date;
  RemoveEntry({
    required this.idUser,
    required this.date,
  });

  @override
  List<Object> get props => [idUser, date];
}
