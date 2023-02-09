// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notification_bloc.dart';

class NotificationState {
  List<String> message;
  NotificationState({
    required this.message,
  });

  NotificationState copyWith({
    List<String>? message,
  }) {
    return NotificationState(
      message: message ?? this.message,
    );
  }
}

class NotificationInitial extends NotificationState {
  NotificationInitial({required super.message});
}
