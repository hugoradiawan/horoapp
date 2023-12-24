import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/uis/interest_page.dart';

class InterestTile extends StatelessWidget {
  const InterestTile({
    super.key,
  });

  @override
  Widget build(_) => InkWell(
        onTap: () => Get.to(() => const InterestPage()),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Interest",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.to(() => const InterestPage()),
                    icon: SvgPicture.asset(
                      'assets/edit.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcATop,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Get.find<AuthController>().profile.value?.interests ==
                          null
                      ? Text(
                          "Add in your interest to find a better match",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        )
                      : Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runAlignment: WrapAlignment.end,
                          children: [
                            for (int i = 0;
                                i <
                                    (Get.find<AuthController>()
                                            .profile
                                            .value
                                            ?.interests
                                            ?.length ??
                                        0);
                                i++)
                              Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    Get.find<AuthController>()
                                        .profile
                                        .value!
                                        .interests![i]
                                        .capitalizeFirst!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
            const Gap(20),
          ]),
        ),
      );
}
