import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterController extends GetxController {
  final RxBool isLogin = true.obs, isObscure = true.obs;
  final PageController pg = PageController();

  void toggleLoginRegister() {
    isLogin.value = !isLogin.value;
    pg.animateToPage(
      isLogin.value ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pg.dispose();
    super.dispose();
  }
}
