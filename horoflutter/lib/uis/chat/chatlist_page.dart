import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/chat.dart';
import 'package:horoflutter/ui_loc/chat_controller.dart';
import 'package:horoflutter/uis/chat/chat_tile.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(_) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Messages',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: ObxValue<RxList<Chat>>(
          (list) => ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (int i = 0; i < list.length; i++) ChatTile(data: list[i]),
            ],
          ),
          Get.find<ChatController>().chats,
        ),
      );
}
