import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'base_client.dart';

class BaseRepository extends BaseClient {
  late Dio dio;

  BaseRepository({Dio? dio}) {
    this.dio = dio ??
        addInterceptors(
          createDio(baseURLOnly),
        );
    if (!kIsWeb) {
      this.dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
  }
}
