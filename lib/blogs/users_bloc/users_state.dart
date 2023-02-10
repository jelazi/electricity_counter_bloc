// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

class UsersState extends Equatable {
  Map<String, String> users;
  List<DateTime> months;
  List<List<String>> entries;

  UsersState({
    required this.users,
    required this.months,
    required this.entries,
  });

  @override
  List<Object> get props => [users, months, entries];

  UsersState copyWith({
    Map<String, String>? users,
    List<DateTime>? months,
    List<List<String>>? entries,
  }) {
    return UsersState(
      users: users ?? this.users,
      months: months ?? this.months,
      entries: entries ?? this.entries,
    );
  }
}

class UsersInitial extends UsersState {
  UsersInitial({users, month, entries})
      : super(
          users: users,
          months: month,
          entries: entries,
        );
}
