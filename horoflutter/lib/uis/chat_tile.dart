import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/chat.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';

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
          onTap: () {},
          leading: CircleAvatar(
            radius: 25,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    Get.find<NestJsConnect>().getProfileUrl(data.profileId[0]),
                fit: BoxFit.cover,
                width: double.infinity,
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
            ),
          ),
          title: Text(
            data.name[0],
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            data.lastMesage,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
}