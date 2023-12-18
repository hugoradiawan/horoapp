import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(_) => Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 29, 64, 69),
              Color.fromARGB(255, 11, 24, 30),
            ],
          ),
        ),
        child: SafeArea(
          child: child,
        ),
      );
}
