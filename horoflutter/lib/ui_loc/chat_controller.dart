import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/chat.dart';
import 'package:horoflutter/business_loc/chatroom.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/uis/chatroom_page.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatController extends GetxController {
  final Socket socket = io(
    'http://${NestJsConnect.ip}:3002/chat',
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  String? roomId;
  final Rxn<Profile> profile = Rxn<Profile>();
  final RxList<Chat> chats = <Chat>[].obs;
  late ChatUser chatter;

  late RxList<ChatMessage> messages = RxList<ChatMessage>(
    <ChatMessage>[ChatMessage(user: chatter, createdAt: DateTime.now())],
  );
  @override
  void onInit() {
    socket.on('onMessage', onMessage);
    socket.on('getRoomId', (data) => roomId = data.toString());
    socket.on('getMessages', onGetMessage);
    socket.on('message', onGetChat);
    final Profile? profile = Get.find<AuthController>().profile.value;
    socket.connect();
    if (profile == null) return;
    chatter = ChatUser(
      id: profile.id!,
      firstName: profile.username,
      profileImage: Get.find<NestJsConnect>().profileUrl,
    );
    super.onInit();
  }

  void requestList() {
    socket.emit('requestList', {
      'userId': chatter.id,
      'roomId': roomId,
    });
  }

  void openRoom(Profile pro) {
    profile.value = pro;
    Get.to(() => const ChatRoomPage());
    socket.emit('openRoom', {
      "users": [chatter.id, pro.id]
    });
  }

  void onGetChat(dynamic data) async {
    final List<dynamic> rawChats = data;
    final List<Chat> result =
        rawChats.map<Chat>((e) => Chat.fromJson(e)).toList().reversed.toList();
    await Future.delayed(const Duration(milliseconds: 500));
    chats.assignAll(result);
  }

  void onGetMessage(dynamic data) {
    final List<dynamic> rawMessages = data;
    messages.assignAll(rawMessages
        .map<ChatMessage>((e) => ChatMessage.fromJson(e))
        .toList()
        .reversed);
    socket.emit('requestList', {'userId': chatter.id});
  }

  void quitRoom() {
    socket.emit('quitRoom', {'roomId': roomId});
    roomId = null;
  }

  void onMessage(dynamic data) {
    if (data is List) return;
    final ChatMessage message = ChatMessage.fromJson(data);
    messages.assignAll([message, ...messages]);
  }

  void createRoom(String chattieId, {String? newRoomId}) {
    if (roomId == null) {
      if (newRoomId != null) {
        roomId = newRoomId;
      } else {
        final Random random = Random();
        roomId = random.nextInt(100).toString();
      }
    }
    final ChatRoom room = ChatRoom(
      users: [chatter.id, chattieId],
      messages: [],
    );
    socket.emit('createRoom', room.toJsonWithoutId());
  }

  void joinRoom(String roomId) {
    this.roomId = roomId;
    socket.emit('joinRoom', {
      'roomId': roomId,
      'userId': chatter.id,
    });
  }

  void sendMessage(ChatMessage message) {
    socket.emit('sentMessage', {
      'roomId': roomId,
      'user': chatter.toJson(),
      'text': message.text,
      'createdAt': DateTime.now().toUtc().toString(),
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}