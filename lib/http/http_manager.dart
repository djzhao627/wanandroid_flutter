import 'package:dio/dio.dart';
import 'package:flutter_app/http/api.dart';

class HttpManager {
  Dio _dio;

  static HttpManager _instance;

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
        receiveTimeout: 10000);
    _dio = Dio(options);
  }

  request(url, {String method = "get"}) async {
    try {
      Options options = Options(method: method);
      Response response = await _dio.request(url, options: options);
      return response.data;
    } catch (e) {
      return null;
    }
  }
}
