// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../models/invoice.dart';
import 'settings_repository.dart';

class InvoicesRepository {
  SettingsRepository settingsRepository;
  var listInvoices = <Invoice>[];

  InvoicesRepository({
    required this.settingsRepository,
  });

  Future<void> initInvoices() async {
    listInvoices = await settingsRepository.getListInvoice();
  }

  void newInvoice() {}
  void deleteInvoice() {}
  void updateInvoice() {}
}
