import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/uis/home_page.dart';
import 'package:horoflutter/uis/login_or_register_page.dart';
import 'package:horoflutter/uis/profile_page.dart';

class UserSwitcher extends GetView<AuthController> {
  const UserSwitcher({super.key});

  @override
  Widget build(_) => Obx(
        () => Navigator(
          pages: [
            if (controller.accessToken.value == null)
              MaterialPage(child: LoginRegisterPage())
            else if (controller.profile.value?.isEmpty() ?? true)
              const MaterialPage(child: ProfilePage())
            else
              const MaterialPage(child: HomePage())
          ],
          onPopPage: (route, result) => route.didPop(result),
        ),
      );
}