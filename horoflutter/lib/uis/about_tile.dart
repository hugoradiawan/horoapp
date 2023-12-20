import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/extensions.dart';
import 'package:intl/intl.dart';

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
                          onPressed: () {},
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

class AboutTextField extends GetView<AboutTileController> {
  const AboutTextField({
    super.key,
    required this.label,
    this.tec,
    this.isNumberic = false,
    this.unit,
    this.isDate = false,
    this.isReadOnly = false,
    this.options = const <String>[],
  });

  final String label;
  final String? unit;
  final bool isNumberic, isDate, isReadOnly;
  final List<String> options;
  final TextEditingController? tec;

  @override
  Widget build(_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "$label:",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              flex: 4,
              child: options.isEmpty
                  ? TextField(
                      controller: tec,
                      textAlign: TextAlign.end,
                      readOnly: isReadOnly || isDate,
                      onTap: isDate ? () => controller.pickDate(tec) : null,
                      keyboardType: isNumberic
                          ? TextInputType.number
                          : TextInputType.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration().horoTransparent(
                        isBordered: true,
                        isDense: true,
                        unit: unit,
                      ),
                    )
                  : CustomDropdown(
                      rxValue: controller.selectedGender,
                      options: options,
                    ),
            ),
          ],
        ),
      );
}

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.rxValue,
    required this.options,
  });

  final RxnString rxValue;
  final List<String> options;

  @override
  Widget build(_) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: Obx(
            () => DropdownButton<String>(
              value: rxValue.value,
              onChanged: rxValue,
              icon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: const Color.fromARGB(255, 11, 24, 30),
              items: options
                  .map(
                    (e) => DropdownMenuItem<String>(
                      alignment: Alignment.centerRight,
                      value: e,
                      child: SizedBox(
                        width: Get.width * 0.45,
                        child: Text(
                          e,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
}

class AboutTileController extends GetxController {
  final RxBool isExpanded = false.obs;
  final ExpansionTileController expansionTileController =
      ExpansionTileController();
  final TextEditingController displayNameTec = TextEditingController(),
      birthdayTec = TextEditingController(),
      horoscopeTec = TextEditingController(),
      zodiacTec = TextEditingController(),
      heightTec = TextEditingController(),
      weightTec = TextEditingController();
  final List<String> genders = ['Male', 'Female'];
  final RxnString selectedGender = RxnString();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy'),
      dateFormatDash = DateFormat('yyyy-MM-dd');
  final Rxn<DateTime> dob = Rxn<DateTime>();
  bool isToUpdate = false;

  @override
  void dispose() {
    displayNameTec.dispose();
    birthdayTec.dispose();
    horoscopeTec.dispose();
    zodiacTec.dispose();
    heightTec.dispose();
    weightTec.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    Get.find<AuthController>().profile.listen((_) => populateProfile());
    super.onInit();
  }

  @override
  void onReady() {
    Get.find<NestJsConnect>().getProfile();
    super.onReady();
  }

  void populateProfile() {
    final Profile? profile = Get.find<AuthController>().profile.value;
    print('populate: ${profile?.toJson()}');
    if (profile == null) return;
    displayNameTec.text = profile.displayName ?? '';
    selectedGender.value = profile.gender == null
        ? null
        : profile.gender!
            ? genders[0]
            : genders[1];
    dob.value = profile.birthday == null
        ? null
        : dateFormatDash.parse(profile.birthday!);
    birthdayTec.text =
        profile.birthday == null ? '' : dateFormat.format(dob.value!);
    horoscopeTec.text = profile.horoscope ?? '';
    zodiacTec.text = profile.zodiac ?? '';
    heightTec.text = profile.height == null ? '' : profile.height!.toString();
    weightTec.text = profile.weight == null ? '' : profile.weight!.toString();
  }

  void pickDate(TextEditingController? tec) async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 90)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Color.fromARGB(255, 29, 64, 69),
            surface: Color.fromARGB(255, 11, 24, 30),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color.fromARGB(255, 11, 24, 30),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    dob.value = date;
    tec?.text = dateFormat.format(date).toUpperCase();
    final date2 = dateFormatDash.format(date);
    final AskHoroscopeZodiacResponse? res =
        await Get.find<NestJsConnect>().askHoroscopeZodiac(date2);
    if (res == null) return;
    horoscopeTec.text = res.horoscope;
    zodiacTec.text = res.zodiac;
  }

  Future<void> saveUpdate() async {
    if (displayNameTec.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Display name cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedGender.value == null) {
      Get.snackbar(
        'Error',
        'Gender must be selected',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (dob.value == null) {
      Get.snackbar(
        'Error',
        'Birthday cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (heightTec.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Height cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (weightTec.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Height cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    bool result = false;
    final Profile? profile = Get.find<AuthController>().profile.value;
    print(profile?.toJson());
    if (profile == null) {
      result = await Get.find<NestJsConnect>().createProfile(Profile(
        displayName: displayNameTec.text,
        birthday: dateFormatDash.format(dob.value!),
        gender: selectedGender.value == genders[0],
        height: int.parse(heightTec.text),
        weight: int.parse(weightTec.text),
      ));
    } else {
      print(profile.toJson());
      final String dashDate = dateFormatDash.format(dob.value!);
      final bool gender = selectedGender.value == genders[0];
      final int height = int.parse(heightTec.text),
          weight = int.parse(weightTec.text);
      result = await Get.find<NestJsConnect>().updateProfile(Profile(
        displayName: displayNameTec.text == profile.displayName
            ? null
            : displayNameTec.text,
        birthday: dashDate == profile.birthday ? null : dashDate,
        gender: gender == profile.gender ? null : gender,
        height: height == profile.height ? null : height,
        weight: weight == profile.weight ? null : weight,
      ));
    }
    if (!result) return;
    expansionTileController.collapse();
  }
}
