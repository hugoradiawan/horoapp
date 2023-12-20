import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';

class Mainbinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}
