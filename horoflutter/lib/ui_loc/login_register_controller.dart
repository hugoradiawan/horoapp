import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/create_user_dto.dart';
import 'package:horoflutter/business_loc/login_user_dto.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';

class LoginRegisterController extends GetxController {
  final RxBool isLogin = true.obs, isObscure = true.obs;
  final PageController pg = PageController();
  final Rx<CreateUserDto> createUserDto = CreateUserDto.init().obs;
  final Rx<LoginUserDto> loginUserDto = LoginUserDto.init().obs;
  final RxString confirmPassword = ''.obs;
  final RxnString usernameError = RxnString(null),
      emailError = RxnString(null),
      passwordError = RxnString(null),
      confirmPasswordError = RxnString(null);

  void toggleLoginRegister() {
    isLogin.value = !isLogin.value;
    pg.animateToPage(
      isLogin.value ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void validateUsername(String value) async {
    if (value.isEmpty) {
      usernameError.value = 'Username is required';
    } else if (await Get.find<NestJsConnect>().isUsernameExist(value)) {
      usernameError.value = 'Username already exists';
    } else if (value.length < 5) {
      usernameError.value = 'Username must be at least 5 characters';
    } else {
      usernameError.value = null;
      createUserDto.update((val) {
        if (val == null) return;
        val.username = value;
      });
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!value.isEmail) {
      emailError.value = 'Email is invalid';
    } else {
      emailError.value = null;
      createUserDto.update((val) {
        if (val == null) return;
        val.email = value;
      });
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else if (!value.isNumericOnly) {
      passwordError.value = 'Password must be numeric only';
    } else {
      passwordError.value = null;
      createUserDto.update((val) {
        if (val == null) return;
        val.password = value;
      });
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
    } else if (value != createUserDto.value.password) {
      confirmPasswordError.value = 'Confirm password does not match';
    } else {
      confirmPasswordError.value = null;
      confirmPassword.value = value;
    }
  }

  Future<bool> login() async {
    if (loginUserDto.value.usernameOrEmail.isEmpty ||
        loginUserDto.value.password.isEmpty) {
      showError('Please fill all fields');
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
      showError('Please fill all fields');
      return false;
    }
    if (createUserDto.value.password != confirmPassword.value) {
      showError('Password and confirm password do not match');
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

  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    Get.closeAllSnackbars();
    pg.dispose();
    super.dispose();
  }
}
