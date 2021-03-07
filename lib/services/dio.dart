import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http://3.138.34.19/api/",
);

final Dio dio = new Dio(options);
