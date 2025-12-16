import 'package:dio/dio.dart';
import 'package:leave_desk/app/api.dart';
import 'package:leave_desk/services/app_service.dart';
import '../app/locator.dart';

class BaseApi {
  AppService? appService = locator<AppService>();

  Dio _getDio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        // connectTimeout: const Duration(seconds: Api.connectionTimeout),
        // receiveTimeout: const Duration(seconds: Api.receiveTimeout),
        // sendTimeout: const Duration(seconds: 10),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${appService!.currentUser != null ? appService!.currentUser!.accessToken : ''}',
        },
      ),
    );

    return dio;
  }

  Future get({required String url, dynamic queryParameters}) {
    return _getDio().get(url, queryParameters: queryParameters);
  }

  Future post({required String url, dynamic data, dynamic queryParameters}) {
    return _getDio().post(url, data: data, queryParameters: queryParameters);
  }

  Future put({required String url, dynamic data, dynamic queryParameters}) {
    return _getDio().put(url, data: data, queryParameters: queryParameters);
  }

  Future delete({required String url, dynamic queryParameters}) {
    return _getDio().delete(url, queryParameters: queryParameters);
  }

  Future patch({required String url, dynamic data}) {
    return _getDio().patch(url, data: data);
  }

  Future postMultipart({required String url, required FormData data, dynamic queryParameters}) {
    return _getDio().post(url, data: data, queryParameters: queryParameters);
  }

  Future putMultipart({required String url, required FormData data, dynamic queryParameters}) {
    return _getDio().put(url, data: data, queryParameters: queryParameters);
  }
}
