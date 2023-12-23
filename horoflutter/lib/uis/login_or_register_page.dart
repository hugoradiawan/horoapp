import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/ui_loc/login_register_controller.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/login_page.dart';
import 'package:horoflutter/uis/register_page.dart';

class LoginRegisterPage extends GetResponsiveView {
  LoginRegisterPage({super.key});

  @override
  Widget builder() => Background(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: screen.height,
              width: screen.width,
              child: GetBuilder<LoginRegisterController>(
                init: LoginRegisterController(),
                builder: (lrc) => Center(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: lrc.pg,
                    children: const [
                      LoginPage(),
                      RegisterPage(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
