import '../services/enum.dart';
import 'hive_provider.dart';

class SettingsRepository {
  String locale = 'cs';
  late HiveProvider _hiveProvider;
  SettingsRepository() {
    _hiveProvider = HiveProvider();
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
}
