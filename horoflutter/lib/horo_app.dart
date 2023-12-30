import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:horoflutter/ui_loc/main_binding.dart';
import 'package:horoflutter/user_switcher.dart';

class HoroApp extends StatelessWidget {
  const HoroApp({super.key});

  @override
  Widget build(_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromARGB(255, 11, 24, 30),
        statusBarBrightness: Brightness.light,
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
