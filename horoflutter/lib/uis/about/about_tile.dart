import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/uis/about/about_textfield.dart';
import 'package:horoflutter/uis/about/about_tile_controller.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({super.key});

  @override
  Widget build(_) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GetX<AboutTileController>(
          init: AboutTileController(),
          builder: (atc) => Stack(
            alignment: Alignment.topCenter,
            children: [
              ExpansionTile(
                controller: atc.expansionTileController,
                backgroundColor: Colors.white.withOpacity(0.1),
                collapsedBackgroundColor: Colors.white.withOpacity(0.1),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                collapsedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                onExpansionChanged: (value) => atc.isExpanded.toggle(),
                controlAffinity: ListTileControlAffinity.trailing,
                trailing: const SizedBox.shrink(),
                title: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                      ),
                      if (!atc.isExpanded.value)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(15),
                            Text(
                              "Add in your profile details to help others know you better",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            const Gap(10),
                          ],
                        )
                      else
                        const SizedBox.shrink()
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Obx(
                          () => InkWell(
                            onTap: atc.pickImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: atc.image.value == null
                                    ? CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: Get.find<NestJsConnect>()
                                            .profileUrl,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          alignment: Alignment.center,
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () => atc.isFetchImageSucceed
                                                .value = false,
                                          );
                                          return const Icon(
                                            Icons.add,
                                            size: 35,
                                            color: Colors.white,
                                          );
                                        },
                                      )
                                    : Image.file(
                                        File(atc.image.value!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Obx(
                          () => TextButton(
                            onPressed: atc.pickImage,
                            child: Text(
                              "${atc.isFetchImageSucceed.value || atc.image.value != null ? 'Change' : 'add'} Image",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AboutTextField(
                    label: "Display Name",
                    tec: atc.displayNameTec,
                  ),
                  AboutTextField(
                    label: "Gender",
                    options: atc.genders,
                  ),
                  AboutTextField(
                    label: "Birthday",
                    tec: atc.birthdayTec,
                    isDate: true,
                  ),
                  AboutTextField(
                    label: "Horoscope",
                    tec: atc.horoscopeTec,
                    isReadOnly: true,
                  ),
                  AboutTextField(
                    label: "Zodiac",
                    tec: atc.zodiacTec,
                    isReadOnly: true,
                  ),
                  AboutTextField(
                    label: "Height",
                    isNumberic: true,
                    tec: atc.heightTec,
                    unit: 'cm',
                  ),
                  AboutTextField(
                    label: "Weight",
                    isNumberic: true,
                    tec: atc.weightTec,
                    unit: 'kg',
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  children: [
                    const Text(
                      "About",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    !atc.isExpanded.value
                        ? IconButton(
                            onPressed: atc.expansionTileController.expand,
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )
                        : TextButton(
                            onPressed: () => atc.saveUpdate(),
                            child: const Text(
                              "Save & Update",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const Gap(20)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
