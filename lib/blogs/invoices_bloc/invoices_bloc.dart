// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:electricity_counter/repositories/invoices_repository.dart';

import '../../models/invoice.dart';
import '../../repositories/settings_repository.dart';
import '../../repositories/users_repository.dart';

part 'invoices_event.dart';
part 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  UsersRepository usersRepository;
  SettingsRepository settingsRepository;
  InvoicesRepository invoicesRepository;

  InvoicesBloc({
    required this.usersRepository,
    required this.settingsRepository,
    required this.invoicesRepository,
  }) : super(InvoicesInitial(
          invoices: const <String, String>{},
          months: const <String>[],
          invoicesData: const <List<String>>[],
        )) {
    on<_InitInvoices>(_initInvoices);
    on<NewInvoice>(_newInvoice);
    on<UpdateInvoice>(_updateInvoice);
    on<DeleteInvoice>(_deleteInvoice);
  }

  void _initInvoices(_InitInvoices event, Emitter<InvoicesState> emit) {}
  void _newInvoice(NewInvoice event, Emitter<InvoicesState> emit) {}
  void _updateInvoice(UpdateInvoice event, Emitter<InvoicesState> emit) {}
  void _deleteInvoice(DeleteInvoice event, Emitter<InvoicesState> emit) {}
}
