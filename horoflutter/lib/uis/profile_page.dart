import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/uis/about/about_tile.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/interest_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(_) => Background(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: InkWell(
              onTap: () => Get.find<AuthController>().erase(),
              child: Obx(() => Text(
                    '@${Get.find<AuthController>().username}',
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => Text(
                          '@${Get.find<AuthController>().username}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              ),
              const Gap(20),
              const AboutTile(),
              const Gap(20),
              const InterestTile(),
            ],
          ),
        ),
      );
}
