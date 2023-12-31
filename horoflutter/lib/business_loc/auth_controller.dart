import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/ui_loc/chat_controller.dart';
import 'package:horoflutter/ui_loc/profile_controller.dart';

class AuthController extends GetxController {
  late final GetStorage _storage;
  static const String acKey = 'accessToken', profileKey = 'profile';
  late RxnString accessToken = RxnString(_storage.read(acKey));
  late Rxn<Profile> profile = Rxn<Profile>(Profile().fromJson(
    _storage.read('profile'),
  ));

  @override
  void onInit() {
    _storage = initStorage();
    ever(accessToken, saveAccessToken);
    ever(profile,
        (Profile? pro) async => _storage.write(profileKey, pro?.toJson()));
    super.onInit();
  }

  GetStorage initStorage() {
    return GetStorage();
  }

  void saveAccessToken(String? token) async {
    _storage.write(acKey, token);
      if (token != null) {
        profile.value = await Get.find<NestJsConnect>().getProfile();
      }
  }

  void updateAccessToken(String? token) {
    if (token == null) return;
    accessToken.value = token;
  }

  void erase() {
    Get.find<ChatController>().quitRoom();
    Get.find<ProfileController>().reload();
    _storage.erase();
    accessToken.value = null;
    profile.value = null;
    imageCache.clear();
    imageCache.clearLiveImages();
  }

  String get username => profile.value?.username ?? '';
}
