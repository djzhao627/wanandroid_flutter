import 'package:dio/dio.dart';
import 'package:flutter_app/http/http_manager.dart';

class Api {
  /// 网站URL
  static const String BASE_URL = "https://www.wanandroid.com/";

  /// 获取首页文章列表
  static const String ARTICLE_LIST = "article/list/";

  /// 获取banner列表
  static const String BANNER = "banner/json";

  /// 登录
  static const String LOGIN = "user/login";

  /// 注册
  static const String REGISTER = "user/register";

  /// 登出
  static const String LOGOUT = "user/logout/json";

  /// 获取收藏的文章列表
  static const String ARTICLE_COLLECT_LIST = "lg/collect/list/";

  /// 获取自定义收藏列表
  static const String CUSTOM_COLLECT_LIST = "lg/collect/usertools/json";

  /// 添加文章收藏
  static const String COLLECT_ARTICLE = "lg/collect/";

  /// 取消文章收藏
  static const String UN_COLLECT_ARTICLE = "lg/uncollect_originId/";

  /// 添加自定义收藏
  static const String COLLECT_CUSTOM = "lg/collect/addtool/json";

  /// 取消自定义收藏
  static const String UN_COLLECT_CUSTOM = "lg/collect/deletetool/json";

  static HttpManager httpManager;

  static init() async {
    httpManager = HttpManager.getInstance();
  }

  static getBanner() async {
    return await httpManager.request(BANNER);
  }

  static getArticleList(int page) async {
    return await httpManager.request("$ARTICLE_LIST$page/json");
  }

  static login(String username, password) async {
    FormData formData =
        FormData.fromMap({"username": username, "password": password});
    return await httpManager.request(LOGIN, data: formData, method: "POST");
  }

  static register(String username, password) async {
    FormData formData = FormData.fromMap(
        {"username": username, "password": password, "repassword": password});
    return await httpManager.request(REGISTER, data: formData, method: "POST");
  }

  static getArticleCollections(int page) async {
    return await httpManager.request("$ARTICLE_COLLECT_LIST$page/json");
  }

  static getCustomCollections() async {
    return await httpManager.request(CUSTOM_COLLECT_LIST);
  }

  static collectArticle(int articleId) async {
    return await httpManager.request("$COLLECT_ARTICLE$articleId/json",
        method: "post");
  }

  static unCollectArticle(int articleId) async {
    return await httpManager.request("$UN_COLLECT_ARTICLE$articleId/json",
        method: "post");
  }

  static collectCustom(String title, String content) async {
    var formData = FormData.fromMap({"name": title, "link": content});
    return await httpManager.request(COLLECT_CUSTOM,
        data: formData, method: "post");
  }

  static unCollectCustom(int id) async {
    var formData = FormData.fromMap({"id": id});
    return await httpManager.request(UN_COLLECT_CUSTOM,
        data: formData, method: "post");
  }

  static void clearUserCookie() {
    httpManager.clearUserCookie();
  }
}
