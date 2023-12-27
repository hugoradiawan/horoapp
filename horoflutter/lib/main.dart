import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horoflutter/business_loc/file_upload_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/horo_app.dart';
import 'package:horoflutter/ui_loc/profile_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    GetStorage.init(),
    initializeDateFormatting('en'),
  ]);
  Get.lazyPut(() => NestJsConnect());
  Get.lazyPut(() => FileUploader());
  Get.lazyPut(() => ProfileController(), fenix: true);
  runApp(const HoroApp());
}
