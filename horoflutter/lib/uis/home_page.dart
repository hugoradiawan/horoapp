import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/ui_loc/home_page_controller.dart';
import 'package:horoflutter/ui_loc/profile_controller.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/chatlist_page.dart';
import 'package:horoflutter/uis/matches_page.dart';
import 'package:horoflutter/uis/profile_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(_) => Background(
        child: GetX<HomePageController>(
          init: HomePageController(),
          builder: (hpc) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/icon.png',
                  height: 40,
                ),
              ),
              title: Obx(
                () => Text(
                  '@${Get.find<AuthController>().username}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.find<AuthController>().erase();
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: BottomNavigationBar(
                useLegacyColorScheme: true,
                type: BottomNavigationBarType.fixed,
                fixedColor: Colors.white,
                showUnselectedLabels: true,
                elevation: 0,
                currentIndex: hpc.tabIndex.value,
                backgroundColor: Colors.transparent,
                unselectedItemColor: Colors.white.withOpacity(0.6),
                onTap: (value) {
                  hpc.tabController.animateTo(value);
                },
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Message',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.contact_mail_sharp),
                    label: 'Contact',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Matches',
                  ),
                  BottomNavigationBarItem(
                    icon: Obx(
                      () => CircleAvatar(
                        radius: 15,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              cacheKey: Get.find<ProfileController>()
                                  .cacheKey
                                  .value
                                  .toString(),
                              imageUrl: Get.find<NestJsConnect>().profileUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorWidget: (context, url, error) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () => Get.find<ProfileController>()
                                      .isFetchImageSucceed
                                      .value = false,
                                );
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    label: 'Profile',
                  ),
                ]),
            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: hpc.tabController,
                children: const [
                  ChatListPage(),
                  Center(
                    child:
                        Text('Contact', style: TextStyle(color: Colors.white)),
                  ),
                  MatchesPage(),
                  ProfileContent(hideAppBar: true),
                ]),
          ),
        ),
      );
}