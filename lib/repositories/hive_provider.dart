import 'package:hive/hive.dart';

import '../services/enum.dart';

class HiveProvider {
  var _settingsBox;
  HiveProvider() {
    _settingsBox = Hive.openBox('settingsBox');
  }

  dynamic getValue(TypeSettingsValue typeSettingsValue) {
    return _settingsBox.get(typeSettingsValue.name);
  }

  void setValue(TypeSettingsValue typeSettingsValue, dynamic value) {
    _settingsBox.put(typeSettingsValue.name, value);
  }
}
