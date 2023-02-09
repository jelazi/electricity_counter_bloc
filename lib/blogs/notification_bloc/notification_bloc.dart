// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/users_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  UsersRepository usersRepository;
  NotificationBloc({
    required this.usersRepository,
  }) : super(NotificationInitial(message: [])) {
    on<CreateMessage>(_onCreateMessage);
    usersRepository.errorMessage.listen((error) {
      add(CreateMessage(message: error));
    });
  }

  void _onCreateMessage(CreateMessage event, Emitter<NotificationState> emit) {
    final state = this.state;
    var listMessage = state.message;
    listMessage.add(event.message);
    if (listMessage.length > 100) {
      listMessage.remove(listMessage.first);
    }
    emit(this.state.copyWith(message: listMessage));
  }
}
