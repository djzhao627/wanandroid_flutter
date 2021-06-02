import 'package:dio/dio.dart';
import 'package:flutter_app/http/http_manager.dart';

class Api {
  static const String BASE_URL = "https://www.wanandroid.com/";

  static const String ARTICLE_LIST = "article/list/";

  static const String BANNER = "banner/json";

  static const String LOGIN = "user/login";

  static const String REGISTER = "user/register";

  static const String LOGOUT = "user/logout/json";

  static const String COLLECT = "lg/collect/list/";

  static getBanner() async {
    return await HttpManager.getInstance().request(BANNER);
  }

  static getArticleList(int page) async {
    return await HttpManager.getInstance().request("$ARTICLE_LIST$page/json");
  }

  static login(String username, password) async {
    FormData formData = FormData.fromMap(
        {"username": username, "password": password});
    return await HttpManager.getInstance().request(LOGIN, data: formData, method: "POST");
  }

  static register(String username, password) async {
    FormData formData = FormData.fromMap(
        {"username": username, "password": password, "repassword": password});
    return await HttpManager.getInstance().request(REGISTER, data: formData, method: "POST");
  }

  static getCollection(int page) async {
    return await HttpManager.getInstance().request("$COLLECT$page/json");
  }

  static void clearUserCookie() {
    HttpManager.getInstance().clearUserCookie();
  }
}
