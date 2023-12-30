import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/ui_loc/chat_controller.dart';
import 'package:horoflutter/uis/background.dart';
import 'package:horoflutter/uis/chat/chat_attachment_option.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomPage extends GetView<ChatController> {
  const ChatRoomPage({super.key});

  @override
  Widget build(_) => Background(
        child: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) controller.quitRoom();
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: AppBar().preferredSize,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.quitRoom();
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
                            imageUrl: controller.profile.value == null
                                ? ''
                                : Get.find<NestJsConnect>().getProfileUrl(
                                    controller.profile.value!.id!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            progressIndicatorBuilder:
                                (context, url, progress) =>
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
                            controller.profile.value == null
                                ? ''
                                : controller.profile.value!.displayName!,
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
              init: controller,
              builder: (cc) => Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  if (cc.chatter.value != null)
                    DashChat(
                      currentUser: cc.chatter.value!,
                      inputOptions: InputOptions(
                        leading: [
                          IconButton(
                            onPressed: () => cc.isAttachmentOpen.toggle(),
                            icon: const Icon(
                              Icons.add_box_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sendButtonBuilder: (onSend) => IconButton(
                          onPressed: onSend,
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                        ),
                        alwaysShowSend: true,
                        inputTextStyle: const TextStyle(color: Colors.white),
                        inputDecoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Type a message',
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onSend: cc.sendMessage,
                      messages: cc.messages.toList(),
                    ),
                  ObxValue<RxBool>(
                    (val) => AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: val.value ? 0 : -Get.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ChatAttachmentOption(
                                  label: 'Photo',
                                  icon: Icons.add_photo_alternate_outlined,
                                  onTap: () => controller
                                      .uploadImage(ImageSource.gallery),
                                ),
                                ChatAttachmentOption(
                                  label: 'Camera',
                                  icon: Icons.add_a_photo_outlined,
                                  onTap: () => controller
                                      .uploadImage(ImageSource.camera),
                                ),
                              ],
                            ),
                          ),
                          const Gap(85),
                        ],
                      ),
                    ),
                    cc.isAttachmentOpen,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
