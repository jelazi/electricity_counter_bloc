// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:electricity_counter/repositories/invoices_repository.dart';
import 'package:electricity_counter/services/enum.dart';

import '../../models/invoice.dart';
import '../../repositories/settings_repository.dart';
import '../../repositories/users_repository.dart';

part 'invoices_event.dart';
part 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  UsersRepository usersRepository;
  SettingsRepository settingsRepository;
  InvoicesRepository invoicesRepository;
  BuildContext context;

  InvoicesBloc({
    required this.usersRepository,
    required this.settingsRepository,
    required this.invoicesRepository,
    required this.context,
  }) : super(InvoicesInitial(
          invoices: const <String, String>{},
          invoicesData: const <List<String>>[],
        )) {
    on<_InitInvoices>(_initInvoices);
    on<NewInvoice>(_newInvoice);
    on<UpdateInvoice>(_updateInvoice);
    on<DeleteInvoice>(_deleteInvoice);
    add(_InitInvoices(invoices: invoicesRepository.listInvoices));
  }

  void _initInvoices(_InitInvoices event, Emitter<InvoicesState> emit) {
    final state = this.state;
    var list = _generateInvoicesTableData(context);
    emit(state.copyWith(invoices: list[0], invoicesData: list[1]));
  }

  void _newInvoice(NewInvoice event, Emitter<InvoicesState> emit) {
    final state = this.state;
    DateTime date = DateTime(event.year, event.month, 1);
    invoicesRepository.newInvoice(
        date, event.fixRate, event.floatingNt, event.floatingVT);
    var list = _generateInvoicesTableData(context);
    emit(state.copyWith(invoices: list[0], invoicesData: list[1]));
  }

  void _updateInvoice(UpdateInvoice event, Emitter<InvoicesState> emit) {}
  void _deleteInvoice(DeleteInvoice event, Emitter<InvoicesState> emit) {}

  List _generateInvoicesTableData(BuildContext context) {
    final listInvoices = invoicesRepository.listInvoices;
    var invoicesName = <String, String>{};
    var invoicesData = List.generate(3, (index) => <String>[]);

    for (var invoice in listInvoices) {
      invoicesName[invoice.id] = getNameMonth(invoice.date);
      invoicesData[0].add(invoice.fixRate.toString());
      invoicesData[1].add(invoice.floatingRateNT.toString());
      invoicesData[2].add(invoice.floatingRateVT.toString());
    }
    return ([invoicesName, invoicesData]);
  }
}
