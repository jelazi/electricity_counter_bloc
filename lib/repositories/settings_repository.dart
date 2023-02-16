import 'package:electricity_counter/models/invoice.dart';
import 'package:electricity_counter/repositories/firebase_provider.dart';

import '../models/user.dart';
import '../services/enum.dart';
import 'hive_provider.dart';

class SettingsRepository {
  String locale = 'cs';
  late HiveProvider _hiveProvider;
  late FirebaseProvider _firebaseProvider;
  SettingsRepository() {
    _hiveProvider = HiveProvider();
    _firebaseProvider = FirebaseProvider();
  }

  Future<void> initBoxes() async {
    await _hiveProvider.initBoxes();
  }

  void _loadAllValues() {
    locale = _hiveProvider.getValue(TypeSettingsValue.locale) ?? locale;
  }

  void _saveAllValues() {
    _hiveProvider.setValue(TypeSettingsValue.locale, locale);
  }

  void _saveValue(TypeSettingsValue typeSettingsValue, dynamic value) {
    switch (typeSettingsValue) {
      case TypeSettingsValue.locale:
        _hiveProvider.setValue(TypeSettingsValue.locale, value);
        break;
    }
  }

  void saveUser(User user) {
    _hiveProvider.setUser(user);
    _firebaseProvider.addUserToFirebase(user);
  }

  void removeUser(User user) {
    _hiveProvider.deleteUser(user);
    _firebaseProvider.deleteUser(user);
  }

  Future<List<User>> getListUser() async {
    return _hiveProvider.getListUser();
  }

  void saveInvoice(Invoice invoice) {
    _hiveProvider.setInvoice(invoice);
    _firebaseProvider.addInvoiceToFirebase(invoice);
  }

  void removeInvoice(Invoice invoice) {
    _hiveProvider.deleteInvoice(invoice);
    _firebaseProvider.deleteInvoice(invoice);
  }

  Future<List<Invoice>> getListInvoice() async {
    return _hiveProvider.getListInvoices();
  }
}
