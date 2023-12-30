import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final DateFormat dateFormatDash = DateFormat('yyyy-MM-dd');
  final Rxn<Profile> profile = Get.find<AuthController>().profile;
  final RxBool isFetchImageSucceed = RxBool(true);
  final RxInt cacheKey = RxInt(0);

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (profile.value?.isEmpty() ?? true) {
        print('profile is empty');
        reload();
      }
    });
    super.onInit();
  }

  int? get age {
    final String? dob = profile.value?.birthday;
    if (dob == null) return null;
    final DateTime bd = dateFormatDash.parse(dob);
    return DateTime.now().difference(bd).inDays ~/ 365;
  }

  Future<void> reload() async {
    isFetchImageSucceed.value = true;
    await Future.delayed(const Duration(milliseconds: 100));
    cacheKey.value = DateTime.now().millisecondsSinceEpoch;
  }

  void updateProfilePicture() async {
    await CachedNetworkImage.evictFromCache(
        Get.find<NestJsConnect>().profileUrl);
    await Future.delayed(const Duration(seconds: 1));
    update();
  }
}
