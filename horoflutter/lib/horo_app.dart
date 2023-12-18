import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:horoflutter/uis/login_or_register_page.dart';
import 'package:horoflutter/ui_loc/login_register_binding.dart';

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
      initialRoute: '/',
      initialBinding: LoginRegisterBinding(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const LoginRegisterPage(),
          binding: LoginRegisterBinding(),
        ),
      ],
    );
  }
}
