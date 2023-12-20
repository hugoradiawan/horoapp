import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/login_page.dart';
import 'package:horoflutter/ui_loc/login_register_controller.dart';
import 'package:horoflutter/uis/register_page.dart';

class LoginRegisterPage extends GetView {
  const LoginRegisterPage({super.key});

  @override
  Widget build(_) => Background(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: GetBuilder<LoginRegisterController>(
                init: LoginRegisterController(),
                builder: (lrc) => PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: lrc.pg,
                    children: const [
                      LoginPage(),
                      RegisterPage(),
                    ],
                  )
              ),
            ),
          ),
        ),
      );
}
