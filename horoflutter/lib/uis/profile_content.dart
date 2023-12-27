import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/ui_loc/profile_controller.dart';
import 'package:horoflutter/uis/about/about_tile.dart';
import 'package:horoflutter/uis/home_page.dart';
import 'package:horoflutter/uis/interest_tile.dart';
import 'package:horoflutter/uis/zoho_chip.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key, this.hideAppBar = false});

  final bool hideAppBar;

  @override
  Widget build(_) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: hideAppBar
            ? null
            : AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: InkWell(
                  onTap: () async {
                    Get.find<AuthController>().erase();
                  },
                  child: Obx(
                    () => Text(
                      '@${Get.find<AuthController>().username}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                actions: [
                  Obx(
                    () =>
                        (Get.find<AuthController>().profile.value?.isEmpty() ??
                                true)
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () => Get.offAll(
                                      () => const HomePage(),
                                      transition: Transition.fadeIn,
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Get.offAll(
                                      () => const HomePage(),
                                      transition: Transition.fadeIn,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                  )
                ],
              ),
        body: GetBuilder<ProfileController>(
          init: Get.find<ProfileController>(),
          builder: (pc) => ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => pc.reload(),
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.1),
                        child: Stack(
                          children: [
                            ColoredBox(
                              color: Colors.white.withOpacity(0.1),
                              child: Obx(
                                () => CachedNetworkImage(
                                  cacheKey: pc.cacheKey.value.toString(),
                                  imageUrl:
                                      Get.find<NestJsConnect>().profileUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorWidget: (context, url, error) {
                                    Future.delayed(
                                      const Duration(milliseconds: 100),
                                      () =>
                                          pc.isFetchImageSucceed.value = false,
                                    );
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  gradient: pc.isFetchImageSucceed.value
                                      ? LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.5),
                                          ],
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '@${pc.profile.value?.username ?? ''}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (pc.age != null)
                                Text(
                                  ', ${pc.age}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          if (!(pc.profile.value?.isEmpty() ?? true))
                            Text(
                              pc.profile.value?.gender == null
                                  ? 'ts'
                                  : pc.profile.value!.gender!
                                      ? 'Male'
                                      : 'Female',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          const Gap(15),
                          if (pc.profile.value?.horoscope != null &&
                              pc.profile.value?.zodiac != null)
                            Row(
                              children: [
                                ZohoChip(
                                  iconName: 'assets/hozo/Horoscope.svg',
                                  data: pc.profile.value!.horoscope!,
                                ),
                                const Gap(10),
                                ZohoChip(
                                  iconName: 'assets/hozo/Zodiac.svg',
                                  data: pc.profile.value!.zodiac!,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
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

// ListView(
//                   children: [
//                     const Gap(10),
//                     ListTile(
//                       title: const Text(
//                         'Match me with everyone',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       trailing: ObxValue<RxBool>(
//                         (val) => Switch(
//                           value: val.value,
//                           onChanged: val,
//                         ),
//                         RxBool(false),
//                       ),
//                     ),
//                     GridView.custom(
//                       gridDelegate: SliverWovenGridDelegate.count(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 8,
//                         crossAxisSpacing: 8,
//                         pattern: [
//                           const WovenGridTile(1),
//                           const WovenGridTile(
//                             5 / 7,
//                             crossAxisRatio: 0.9,
//                             alignment: AlignmentDirectional.centerEnd,
//                           ),
//                         ],
//                       ),
//                       childrenDelegate: SliverChildBuilderDelegate(
//                         (context, index) => Container(),
//                       ),
//                     ),
//                   ],
//                 )