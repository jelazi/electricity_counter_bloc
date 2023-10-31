// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class _CreateUsers extends UsersEvent {
  final List<User> users;
  const _CreateUsers({required this.users});

  @override
  List<Object> get props => [users];
}

class AddUser extends UsersEvent {
  final String nameUser;
  const AddUser({required this.nameUser});

  @override
  List<Object> get props => [nameUser];
}

class RemoveUser extends UsersEvent {
  final String id;
  const RemoveUser({required this.id});

  @override
  List<Object> get props => [id];
}

class ChangeOrderUsers extends UsersEvent {
  final List<String> nameOrder;
  const ChangeOrderUsers({required this.nameOrder});

  @override
  List<Object> get props => [nameOrder];
}

class AddEntry extends UsersEvent {
  final String idUser;
  final DateTime date;
  final double nt;
  final double vt;
  const AddEntry({
    required this.idUser,
    required this.date,
    required this.nt,
    required this.vt,
  });

  @override
  List<Object> get props => [idUser, date, nt, vt];
}

class AddListEntry extends UsersEvent {
  final List<List<String>> entries;
  final int year;
  final int month;
  const AddListEntry({
    required this.entries,
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [entries, year, month];
}

class RemoveEntry extends UsersEvent {
  final String idUser;
  final DateTime date;
  const RemoveEntry({
    required this.idUser,
    required this.date,
  });

  @override
  List<Object> get props => [idUser, date];
}
