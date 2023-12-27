import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/ui_loc/chat_controller.dart';
import 'package:horoflutter/uis/background.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(_) => Background(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.find<ChatController>().quitRoom();
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Obx(
                        () => CachedNetworkImage(
                          imageUrl:
                              Get.find<ChatController>().profile.value == null
                                  ? ''
                                  : Get.find<NestJsConnect>().getProfileUrl(
                                      Get.find<ChatController>()
                                          .profile
                                          .value!
                                          .id!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              CircularProgressIndicator(
                            value: progress.progress,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          Get.find<ChatController>().profile.value == null
                              ? ''
                              : Get.find<ChatController>()
                                  .profile
                                  .value!
                                  .displayName!,
                          style: const TextStyle(color: Colors.white),
                        )),
                    Text(
                      'Online',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: GetX<ChatController>(
            init: Get.find<ChatController>(),
            builder: (cc) => DashChat(
              currentUser: cc.chatter,
              onSend: cc.sendMessage,
              messages: cc.messages.toList(),
            ),
          ),
        ),
      );
}
