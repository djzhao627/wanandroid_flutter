import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HttpManager {
  Dio _dio;

  static HttpManager _instance;

  PersistCookieJar _persistCookieJar;

  factory HttpManager.getInstance() {
    if (_instance == null) {
      _instance = HttpManager._internal();
    }
    return _instance;
  }

  /// _ 开头的函数、变量在库外无法调用
  HttpManager._internal() {
    BaseOptions options = BaseOptions(
        baseUrl: Api.BASE_URL,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        sendTimeout: 10000);
    _dio = Dio(options);
    _initDio();
  }

  void _initDio() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = Directory(join(directory.path, "cookie")).path;
    _persistCookieJar = PersistCookieJar(storage: FileStorage(path));
    _dio.interceptors.add(CookieManager(_persistCookieJar));
  }

  request(url, {String method = "get", data}) async {
    try {
      debugPrint(
          "Request:\n==========================\nurl:$url\nmethod:$method\ndata:$data\n==========================");
      Options options = Options(method: method);
      Response response = await _dio.request(url, data: data, options: options);
      debugPrint(
          "Response:\n==========================\nheaders:${response.headers}\ndata:${response.data}\n==========================");
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void clearUserCookie() {
    _persistCookieJar.deleteAll();
  }
}
