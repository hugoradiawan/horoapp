import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';

class InterestPageController extends GetxController {
  final RxList<String> interests = <String>[].obs;
  final TextEditingController tec = TextEditingController();

  @override
  void onInit() {
    Get.find<AuthController>().profile.value?.interests?.addAll(interests);
    super.onInit();
  }

  @override
  void dispose() {
    tec.dispose();
    super.dispose();
  }

  void addNew() {
    if (tec.text.trim().isEmpty) return;
    interests.add(tec.text.trim().toLowerCase());
    tec.clear();
  }

  void remove(String interest) {
    interests.remove(interest);
  }

  void save() async {
    FocusScope.of(Get.context!).unfocus();
    final bool isSucceed = await Get.find<NestJsConnect>()
        .updateProfile(Profile(interests: interests));
    if (isSucceed) {
      unawaited(Get.find<NestJsConnect>().getProfile());
      Get.back();
      Get.snackbar(
        'Success',
        'Interest updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to update interest',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
