import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/ui_loc/main_binding.dart';
import 'package:horoflutter/uis/home_page.dart';
import 'package:horoflutter/uis/login_or_register_page.dart';
import 'package:horoflutter/uis/profile_page.dart';

class HoroApp extends StatelessWidget {
  const HoroApp({super.key});

  @override
  Widget build(_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return GetMaterialApp(
      title: 'Horo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 29, 64, 69),
        ),
        useMaterial3: true,
      ),
      initialBinding: Mainbinding(),
      home: const UserSwitcher(),
    );
  }
}

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
