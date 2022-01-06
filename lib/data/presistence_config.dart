import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesEnum {
  ALARM,
  HISTORY
}

class PresistenceConfig {

  PresistenceConfig._();

  static PresistenceConfig _presistenceConfig;

  factory PresistenceConfig.getInstance() {
    if(_presistenceConfig == null){
      _presistenceConfig = PresistenceConfig._();
    }
    return _presistenceConfig;
  }

  Future<String> getPreferences(PreferencesEnum key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String data = prefs.getString(key.toString());
      if (data == null) {
        return null;
      }
      return data;
    } on Exception {
      return null;
    }
  }

  Future<bool> setPreferences(PreferencesEnum key, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString(key.toString(), value);
    } on Exception {
      throw Exception("Error");
    }
  }

  Future<bool> removePreferences(PreferencesEnum key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.remove(key.toString());
    } on Exception {
      throw Exception("Error");
    }
  }

}