import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/create_user_dto.dart';
import 'package:horoflutter/login_user_dto.dart';
import 'package:horoflutter/nestjs_connect.dart';

class LoginRegisterController extends GetxController {
  final RxBool isLogin = true.obs, isObscure = true.obs;
  final PageController pg = PageController();
  final Rx<CreateUserDto> createUserDto = CreateUserDto.init().obs;
  final Rx<LoginUserDto> loginUserDto = LoginUserDto.init().obs;
  final RxString confirmPassword = ''.obs;

  void toggleLoginRegister() {
    isLogin.value = !isLogin.value;
    pg.animateToPage(
      isLogin.value ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> login() async {
    if (loginUserDto.value.usernameOrEmail.isEmpty ||
        loginUserDto.value.password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    final bool result =
        await Get.find<NestJsConnect>().login(loginUserDto.value);
    if (result) {
      Get.snackbar(
        'Success',
        'You have successfully logged in.',
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      loginUserDto.value = LoginUserDto.init();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register() async {
    if (createUserDto.value.username.isEmpty ||
        createUserDto.value.password.isEmpty ||
        confirmPassword.value.isEmpty ||
        createUserDto.value.email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (createUserDto.value.password != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'Password and confirm password must be same',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    final bool result =
        await Get.find<NestJsConnect>().register(createUserDto.value);
    if (result) {
      Get.snackbar(
        'Success',
        'You have successfully registered. Please login now.',
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      toggleLoginRegister();
      createUserDto.value = CreateUserDto.init();
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    pg.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    createUserDto.listen((p0) {
      print(p0.toJson);
    });
    super.onInit();
  }
}
