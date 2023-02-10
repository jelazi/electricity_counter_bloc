// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:uuid/uuid.dart';

import '../models/invoice.dart';
import 'settings_repository.dart';
import 'package:collection/collection.dart';

class InvoicesRepository {
  SettingsRepository settingsRepository;
  final _errorMessageController = StreamController<String>();
  Stream<String> get errorMessage => _errorMessageController.stream;
  var listInvoices = <Invoice>[];

  InvoicesRepository({
    required this.settingsRepository,
  });

  Future<void> initInvoices() async {
    listInvoices = await settingsRepository.getListInvoice();
    // FLog.debug(text: 'init${listInvoices.length}');
  }

  Invoice? newInvoice(DateTime date, double fixRate, double floatingRateNT,
      double floatingRateVT) {
    if (listInvoices.firstWhereOrNull((element) => element.date == date) !=
        null) {
      FLog.warning(text: 'this user name is already in use');
      _errorMessageController.add('this user name is already in use');
      return null;
    }
    var uuid = const Uuid();
    Invoice invoice = Invoice(
        id: uuid.v4(),
        date: date,
        fixRate: fixRate,
        floatingRateNT: floatingRateNT,
        floatingRateVT: floatingRateVT);

    listInvoices.add(invoice);
    settingsRepository.saveInvoice(invoice);
  }

  void deleteInvoice() {}
  void updateInvoice() {}
}
