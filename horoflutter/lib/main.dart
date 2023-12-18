import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/horo_app.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';

void main() {
  Get.lazyPut(() => NestJsConnect());
  runApp(const HoroApp());
}
