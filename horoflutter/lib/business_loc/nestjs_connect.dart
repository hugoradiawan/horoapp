import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/create_user_dto.dart';
import 'package:horoflutter/business_loc/login_user_dto.dart';
import 'package:horoflutter/business_loc/server_response.dart';

class NestJsConnect extends GetConnect {
  @override
  void onInit() {
    const String ip = '192.168.1.100';
    httpClient.baseUrl = 'http://$ip:3000/api/';
  }

  Future<Response> askHoroscopeZodiac(String birthday) =>
      post('askHoroscopeZodiac', {'birthday': birthday});

  Future<bool> register(CreateUserDto createUserDto) async {
    final Response res = await post('register', createUserDto.toJson);
    if (res.status.isOk) {
      return true;
    } else {
      final ServerResponse serverResponse = ServerResponse.fromJson(res.body);
      Get.snackbar(
        'Error',
        serverResponse.message ?? ' (${serverResponse.errorCode})',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> login(LoginUserDto loginUserDto) async {
    final Response res = await post('login', loginUserDto.toJson);
    if (res.status.isOk) {
      final ServerResponse serverResponse = ServerResponse.fromJson(res.body);
      print(serverResponse.toJson);
      return true;
    } else {
      final ServerResponse serverResponse = ServerResponse.fromJson(res.body);
      Get.snackbar(
        'Error',
        serverResponse.message ?? ' (${serverResponse.errorCode})',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
