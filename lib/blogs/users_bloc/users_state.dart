// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

class UsersState extends Equatable {
  final Map<String, String> users;
  final List<DateTime> months;
  final List<List<String>> entries;
  final List<List<double?>> nts;
  final List<List<double?>> vts;
  final List<Measure> listMeasure;

  const UsersState({required this.users, required this.months, required this.entries, required this.nts, required this.vts, required this.listMeasure});

  @override
  List<Object> get props {
    return [users, months, entries, nts, vts, listMeasure];
  }

  UsersState copyWith({
    Map<String, String>? users,
    List<DateTime>? months,
    List<List<String>>? entries,
    List<List<double?>>? nts,
    List<List<double?>>? vts,
    List<Measure>? listMeasure,
  }) {
    return UsersState(
      users: users ?? this.users,
      months: months ?? this.months,
      entries: entries ?? this.entries,
      nts: nts ?? this.nts,
      vts: vts ?? this.vts,
      listMeasure: listMeasure ?? this.listMeasure,
    );
  }

  @override
  bool get stringify => true;
}

class UsersInitial extends UsersState {
  UsersInitial({users, month, entries, nts, vts, listMeasure}) : super(users: users, months: month, entries: entries, nts: nts, vts: vts, listMeasure: listMeasure);
}
