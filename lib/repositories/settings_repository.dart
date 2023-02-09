import '../models/user.dart';
import '../services/enum.dart';
import 'hive_provider.dart';

class SettingsRepository {
  String locale = 'cs';
  late HiveProvider _hiveProvider;
  SettingsRepository() {
    _hiveProvider = HiveProvider();
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
  }

  void removeUser(User user) {
    _hiveProvider.deleteUser(user);
  }

  Future<List<User>> getListUser() async {
    return _hiveProvider.getListUser();
  }
}
