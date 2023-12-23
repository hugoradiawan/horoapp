import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/ask_horoscope_zodiac_response.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/create_user_dto.dart';
import 'package:horoflutter/business_loc/jwt.dart';
import 'package:horoflutter/business_loc/login_user_dto.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/business_loc/server_response.dart';

class NestJsConnect extends GetConnect {
  @override
  void onInit() {
    const String ip = '192.168.1.100';
    httpClient.baseUrl = 'http://$ip:3000/api/';
    httpClient.addRequestModifier<dynamic>((request) {
      final String? token = Get.find<AuthController>().accessToken.value;
      if (token != null) {
        request.headers['x-access-token'] = token;
      }
      return request;
    });
  }

  String get profileUrl =>
      '${Get.find<NestJsConnect>().httpClient.baseUrl!}file/${Get.find<AuthController>().profile.value!.id!}';

  Future<AskHoroscopeZodiacResponse?> askHoroscopeZodiac(
      String birthday) async {
    final Response res =
        await post('askHoroscopeZodiac', {'birthday': birthday});
    if (res.status.isOk) {
      final ServerResponse<AskHoroscopeZodiacResponse> serverResponse =
          ServerResponse.fromJson(
        res.body,
        fromJson: (json) => AskHoroscopeZodiacResponse(json),
      );
      return serverResponse.data;
    } else {
      handleError(res);
      return null;
    }
  }

  Future<bool> register(CreateUserDto createUserDto) async {
    final Response res = await post('register', createUserDto.toJson);
    if (res.status.isOk) {
      return true;
    } else {
      handleError(res);
      return false;
    }
  }

  Future<bool> login(LoginUserDto loginUserDto) async {
    final Response res = await post('login', loginUserDto.toJson);
    if (res.status.isOk) {
      final ServerResponse<Jwt> serverResponse =
          ServerResponse.fromJson(res.body, fromJson: (json) => Jwt(json));
      Get.find<AuthController>()
          .updateAccessToken(serverResponse.data?.accessToken);
      return true;
    } else {
      handleError(res);
      return false;
    }
  }

  Future<Profile?> getProfile() async {
    print(Get.find<NestJsConnect>().baseUrl);
    final Response res = await get('getProfile');
    if (res.status.isOk) {
      final ServerResponse<Profile> serverResponse = ServerResponse.fromJson(
        res.body,
        fromJson: (json) => Profile().fromJson(json) ?? Profile(),
      );
      Get.find<AuthController>().profile.value = serverResponse.data;
      return serverResponse.data;
    } else {
      final ServerResponse<Object?> serverResponse =
          ServerResponse<Profile>.fromJson(res.body);
      if (serverResponse.errorCode == 1000) {
        Get.find<AuthController>().profile.value = null;
        return null;
      } else {
        handleError(res);
        return null;
      }
    }
  }

  Future<bool> createProfile(Profile profile) async {
    print(profile.toJson());
    final Response res = await post('createProfile', profile.toJson());
    if (res.status.isOk) {
      unawaited(getProfile());
      return true;
    } else {
      handleError(res);
      return false;
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    print(profile.toJson(withUsername: false));
    final Response res =
        await put('updateProfile', profile.toJson(withUsername: false));
    print(res.statusCode);
    if (res.status.isOk) {
      return true;
    } else {
      unawaited(getProfile());
      handleError(res);
      return false;
    }
  }

  void handleError(Response res) {
    final ServerResponse serverResponse = ServerResponse.fromJson(res.body);

    Get.snackbar(
      'Error',
      '${serverResponse.message ?? ''} (${serverResponse.errorCode})',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
