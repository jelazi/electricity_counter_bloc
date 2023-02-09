import 'package:f_logs/f_logs.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';
import '../services/enum.dart';

class HiveProvider {
  var _settingsBox;
  var _usersBox;
  HiveProvider() {}

  Future<void> initBoxes() async {
    _settingsBox = await Hive.openBox('settingsBox');
    _usersBox = await Hive.openBox<User>("usersBox");
  }

  dynamic getValue(TypeSettingsValue typeSettingsValue) {
    return _settingsBox.get(typeSettingsValue.name);
  }

  void setValue(TypeSettingsValue typeSettingsValue, dynamic value) {
    _settingsBox.put(typeSettingsValue.name, value);
  }

  Future<void> setUser(User user) async {
    List listUser = await _usersBox.values.cast().toList();
    for (var i = 0; i < listUser.length; i++) {
      if (listUser[i].name == user.name) {
        await _usersBox.putAt(i, user);
        return;
      }
    }
    await _usersBox.add(user);
  }

  Future<List<User>> getListUser() async {
    var listUser = await _usersBox.values.cast().toList();
    return List<User>.from(listUser);
  }

  Future<void> deleteUser(User user) async {
    List listUser = await _usersBox.values.cast().toList();
    for (var u in listUser) {
      if (u.id == user.id) {
        _usersBox.deleteAt(listUser.indexOf(u));
        _usersBox.compact();
      }
    }
  }
}
