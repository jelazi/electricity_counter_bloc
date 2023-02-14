// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

class UsersState extends Equatable {
  Map<String, String> users;
  List<DateTime> months;
  List<List<String>> entries;
  List<List<double?>> nts;
  List<List<double?>> vts;

  UsersState({
    required this.users,
    required this.months,
    required this.entries,
    required this.nts,
    required this.vts,
  });

  @override
  List<Object> get props => [users, months, entries];

  UsersState copyWith({
    Map<String, String>? users,
    List<DateTime>? months,
    List<List<String>>? entries,
    List<List<double?>>? nts,
    List<List<double?>>? vts,
  }) {
    return UsersState(
      users: users ?? this.users,
      months: months ?? this.months,
      entries: entries ?? this.entries,
      nts: nts ?? this.nts,
      vts: vts ?? this.vts,
    );
  }
}

class UsersInitial extends UsersState {
  UsersInitial({users, month, entries, nts, vts})
      : super(
          users: users,
          months: month,
          entries: entries,
          nts: nts,
          vts: vts,
        );
}
