import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchesPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
