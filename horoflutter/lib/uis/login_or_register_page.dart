import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/login_page.dart';
import 'package:horoflutter/ui_loc/login_register_controller.dart';
import 'package:horoflutter/uis/register_page.dart';

class LoginRegisterPage extends GetView<LoginRegisterController> {
  const LoginRegisterPage({super.key});

  @override
  Widget build(_) => Background(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pg,
                children: const [
                  LoginPage(),
                  RegisterPage(),
                ],
              ),
            ),
          ),
        ),
      );
}
