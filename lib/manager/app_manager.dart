import 'package:event_bus/event_bus.dart';
import 'package:flutter_app/http/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppManager {
  static const String ACCOUNT = "accountName";
  static EventBus eventBus = EventBus();
  static SharedPreferences sharedPreferences;

  static initApp() async {
    await Api.init();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static isLogin() {
    return sharedPreferences.getString(ACCOUNT) != null;
  }
}
