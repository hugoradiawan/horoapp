import 'package:get/get.dart';
import 'package:horoflutter/login_register_controller.dart';

class LoginRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginRegisterController());
  }
}
