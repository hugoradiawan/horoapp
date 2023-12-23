import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/ask_horoscope_zodiac_response.dart';
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
  final ImagePicker imagePicker = ImagePicker();
  final Rxn<XFile> image = Rxn<XFile>();
  final RxBool isFetchImageSucceed = RxBool(true);

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

  Future<void> _uploadImage() async {
    if (image.value == null) return;
    final bool result = await Get.find<FileUploader>().upload(image.value!);
    if (!result) return;
    image.value = null;
    await CachedNetworkImage.evictFromCache(
        Get.find<NestJsConnect>().profileUrl);
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

  void validate() {
    if (displayNameTec.text.isEmpty) {
      showError('Display name cannot be empty');
      return;
    }
    if (selectedGender.value == null) {
      showError('Gender must be selected');
      return;
    }
    if (dob.value == null) {
      showError('Birthday cannot be empty');
      return;
    }
    if (heightTec.text.isEmpty) {
      showError('Height cannot be empty');
      return;
    }
    if (weightTec.text.isEmpty) {
      showError('Weight cannot be empty');
      return;
    }
  }

  Future<void> saveUpdate() async {
    validate();
    _uploadImage();
    bool result = false;
    final Profile? profile = Get.find<AuthController>().profile.value;
    final String dashDate = dateFormatDash.format(dob.value!);
    final bool gender = selectedGender.value == genders[0];
    final int height = int.parse(heightTec.text),
        weight = int.parse(weightTec.text);
    if (profile == null) {
      result = await Get.find<NestJsConnect>().createProfile(Profile(
        displayName: displayNameTec.text,
        birthday: dashDate,
        gender: gender,
        height: height,
        weight: weight,
      ));
    } else {
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
    Get.snackbar(
      'Success',
      'Profile updated',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
