import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';

class AuthController extends GetxController {
  final GetStorage _storage = GetStorage();
  static const String acKey = 'accessToken', profileKey = 'profile';
  late RxnString accessToken = RxnString(_storage.read(acKey));
  late Rxn<Profile> profile = Rxn<Profile>(Profile(username: "hugo").fromJson(
    _storage.read('profile'),
  ));

  @override
  void onInit() {
    ever(accessToken, (String? token) async {
      _storage.write(acKey, token);
      if (token != null) {
        profile.value = await Get.find<NestJsConnect>().getProfile();
      }
    });
    ever(profile,
        (Profile? pro) async => _storage.write(profileKey, pro?.toJson()));
    super.onInit();
  }

  void updateAccessToken(String? token) {
    if (token == null) return;
    accessToken.value = token;
  }

  void erase() {
    _storage.erase();
    accessToken.value = null;
    profile.value = null;
  }
}
