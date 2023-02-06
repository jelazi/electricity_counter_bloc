// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

class UsersState extends Equatable {
  List<User> users;
  UsersState({
    required this.users,
  });

  @override
  List<Object> get props => [users];

  UsersState copyWith({
    List<User>? users,
  }) {
    return UsersState(
      users: users ?? this.users,
    );
  }
}

class UsersInitial extends UsersState {
  UsersInitial({users}) : super(users: users);
}
