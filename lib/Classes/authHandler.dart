import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthHandler {
  final storage = FlutterSecureStorage();
  Map<String, dynamic> fileContent;

  AuthHandler();

  Future<void> setAuthToken(String token) async {
    await storage.write(key: 'authToken', value: token);
  }

  Future<String> getAuthToken() async {
    String token = await storage.read(key: 'authToken');
    return token;
  }

  Future<void> deleteAuthToken() async {
    await storage.delete(key: 'authToken');
  }
}
