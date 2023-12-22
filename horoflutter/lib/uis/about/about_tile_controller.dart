import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/file_upload_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  final ImagePicker imagePicker = ImagePicker();
  final Rxn<XFile> image = Rxn<XFile>();
  final RxnBool isFetchImageSucceed = RxnBool();

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

  void pickImage() async {
    image.value = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  void _uploadImage() async {
    if (image.value == null) return;
    final bool result = await Get.find<FileUploader>().upload(image.value!);
    if (!result) return;
    image.value = null;
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
