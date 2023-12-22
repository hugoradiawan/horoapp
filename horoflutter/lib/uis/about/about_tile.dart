import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/file_upload_controller.dart';
import 'package:horoflutter/uis/about/about_textfield.dart';
import 'package:horoflutter/uis/about/about_tile_controller.dart';
import 'package:image_picker/image_picker.dart';

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
                        FloatingActionButton(
                          elevation: 0,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          onPressed: () async {
                            final XFile? xFile = await Get.find<FileUploader>()
                                .getFile(ImageSource.gallery);
                            if (xFile == null) return;
                            final bool result =
                                await Get.find<FileUploader>().upload(xFile);
                            if (result) {
                              print('success');
                            } else {
                              print('failed');
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(20),
                        const Text(
                          "Add Image",
                          style: TextStyle(color: Colors.white),
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

