import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/chat.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/ui_loc/chat_controller.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.data,
  });

  final Chat data;

  @override
  Widget build(_) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.05),
        ),
        child: ListTile(
          onTap: () {
            Get.find<ChatController>().openRoom(Profile(
              id: data.profileId[0],
              displayName: data.name[0],
            ));
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: data.profileId.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: Get.find<NestJsConnect>()
                          .getProfileUrl(data.profileId[0]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
          ),
          title: Text(
            data.name.isNotEmpty ? data.name[0] : '',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            data.lastMesage,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
}
