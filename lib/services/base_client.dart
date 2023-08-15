import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_robinhood/services/api_const.dart';
import 'package:test_robinhood/services/base_Interceptors.dart';

class BaseClient extends ApiBasePath {
  Dio createDio(String baseUrl) {
    return Dio(BaseOptions(
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 3),
      baseUrl: baseUrl,
    ));
  }

  Dio addInterceptors(Dio dio, {List<String>? exceptionURL}) {
    return dio
      ..interceptors.add(CustomInterceptors())
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
  }
}
