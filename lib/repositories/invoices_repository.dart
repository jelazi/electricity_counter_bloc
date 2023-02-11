// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:uuid/uuid.dart';

import '../models/entry.dart';
import '../models/invoice.dart';
import '../models/result.dart';
import 'settings_repository.dart';
import 'package:collection/collection.dart';

import 'users_repository.dart';

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

  void deleteInvoice(Invoice invoice) {
    listInvoices.removeWhere((element) => element.id == invoice.id);
    settingsRepository.removeInvoice(invoice);
  }

  void updateInvoice(Invoice invoice) {
    listInvoices.insert(
        listInvoices.indexWhere((element) => element.id == invoice.id),
        invoice);
    settingsRepository.saveInvoice(invoice);
  }

  Invoice? getInvoiceByDate(DateTime dateTime) {
    for (var invoice in listInvoices) {
      if (invoice.date.year == dateTime.year &&
          invoice.date.month == dateTime.month) {
        return invoice;
      }
    }
    return null;
  }

  Invoice? getInvoiceById(String id) {
    return listInvoices.firstWhereOrNull((element) => element.id == id);
  }

  Result sumResult(Invoice invoice, List<Entry> listEntries,
      UsersRepository usersRepository) {
    Result result = Result(date: invoice.date);

    for (var entry in listEntries) {
      if (!result.listName
          .contains(usersRepository.getUserById(entry.idUser)?.name ?? '')) {
        result.listName
            .add(usersRepository.getUserById(entry.idUser)?.name ?? '');
      }
    }
    double sumNt = 0;
    double sumVT = 0;
    result.listData = List.generate(result.listName.length, (index) => []);
    for (var entry in listEntries) {
      sumNt += entry.nt;
      sumVT += entry.vt;
    }
    for (var entry in listEntries) {
      double entryNt = entry.nt;
      double percentNt = entry.nt / (sumNt / 100);
      double priceNt = invoice.floatingRateNT / sumNt * entry.nt;
      double entryVt = entry.vt;
      double percentVt = entry.vt / (sumVT / 100);
      double priceVt = invoice.floatingRateVT / sumVT * entry.vt;
      double fix = invoice.fixRate / result.listName.length;
      double sum = priceNt + priceVt + fix;
      double ratioNT = priceNt / ((priceNt + priceVt) / 100);
      double ratioVT = priceVt / ((priceNt + priceVt) / 100);

      result.listData[listEntries.indexOf(entry)].add(entryNt);
      result.listData[listEntries.indexOf(entry)].add(percentNt);
      result.listData[listEntries.indexOf(entry)].add(priceNt);
      result.listData[listEntries.indexOf(entry)].add(entryVt);
      result.listData[listEntries.indexOf(entry)].add(percentVt);
      result.listData[listEntries.indexOf(entry)].add(priceVt);
      result.listData[listEntries.indexOf(entry)].add(fix);
      result.listData[listEntries.indexOf(entry)].add(sum);
      result.listData[listEntries.indexOf(entry)].add(ratioNT);
      result.listData[listEntries.indexOf(entry)].add(ratioVT);
    }

    return result;
  }
}
