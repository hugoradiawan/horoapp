import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horoflutter/business_loc/auth_controller.dart';
import 'package:horoflutter/business_loc/chat.dart';
import 'package:horoflutter/business_loc/file_upload_controller.dart';
import 'package:horoflutter/business_loc/nestjs_connect.dart';
import 'package:horoflutter/business_loc/profile.dart';
import 'package:horoflutter/uis/chat/chatroom_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatController extends GetxController {
  final Socket socket = io(
    'http://${Get.find<NestJsConnect>().ip}:3002/chat',
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  String? roomId;
  final String chatKey = 'chat';
  final Rxn<Profile> profile = Rxn<Profile>();
  late RxList<Chat> chats = RxList<Chat>(localData);
  final Rxn<ChatUser> chatter = Rxn<ChatUser>();
  final ImagePicker picker = ImagePicker();
  final RxBool isAttachmentOpen = false.obs;

  late RxList<ChatMessage> messages = RxList<ChatMessage>(
    <ChatMessage>[],
  );

  @override
  void onInit() {
    socket.on('onMessage', onMessage);
    socket.on('getRoomId', (data) => roomId = data.toString());
    socket.on('getMessages', onGetMessage);
    socket.on('message', onGetChat);
    socket.connect();
    updateChatter();
    messages = RxList<ChatMessage>(
      <ChatMessage>[
        ChatMessage(user: chatter.value!, createdAt: DateTime.now())
      ],
    );
    requestList();
    chats.listen((_) =>
        GetStorage().write(chatKey, chats.map((e) => e.toJson()).toList()));
    messages.listen((_) {
      for (var i = 0; i < messages.length; i++) {
        if (messages[i].text.isNotEmpty) continue;
        messages[i].medias?[0].url =
            '${Get.find<NestJsConnect>().gridFsUrl}file/${messages[i].medias?[0].fileName}';
      }
    });
    Get.find<AuthController>().profile.listen((p0) => updateChatter());
    super.onInit();
  }

  void requestList() {
    if (chatter.value == null) {
      print('chatter is null');
      return;
    }
    if (roomId == null) {
      print('roomId is null');
      return;
    }
    socket.emit('requestList', {
      'userId': chatter.value?.id,
      'roomId': roomId,
    });
  }

  List<Chat> get localData {
    final List rawChats = GetStorage().read<List<dynamic>>(chatKey) ?? [];
    return rawChats.map<Chat>((e) => Chat.fromJson(e)).toList();
  }

  void openRoom(Profile pro) {
    profile.value = pro;
    if (chatter.value?.id == pro.id) {
      print('same user');
      return;
    }
    Get.to(() => const ChatRoomPage());
    socket.emit('openRoom', {
      "users": [chatter.value?.id, pro.id]
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
    socket.emit('requestList', {'userId': chatter.value?.id});
  }

  void quitRoom() {
    socket.emit('quitRoom', {
      'roomId': roomId,
      'userId': chatter.value?.id,
    });
    roomId = null;
  }

  void onMessage(dynamic data) {
    if (data is List) return;
    final ChatMessage message = ChatMessage.fromJson(data);
    messages.assignAll([message, ...messages]);
  }

  void joinRoom(String roomId) {
    this.roomId = roomId;
    if (chatter.value == null) {
      print('chatter is null');
      return;
    }
    if (this.roomId == null) {
      print('roomId is null');
      return;
    }
    socket.emit('joinRoom', {
      'roomId': roomId,
      'userId': chatter.value?.id,
    });
  }

  void updateChatter() {
    final Profile? profile = Get.find<AuthController>().profile.value;
    if (profile == null) return;
    chatter.value = ChatUser(
      id: profile.id!,
      firstName: profile.username,
      profileImage: Get.find<NestJsConnect>().profileUrl,
    );
  }

  Future<void> uploadImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;
    final String? fileName =
        await Get.find<FileUploader>().uploadChatImage(image);
    if (fileName == null) return;
    if (chatter.value == null) {
      print('chatter is null');
      return;
    }
    final ChatMessage message = ChatMessage(
      user: chatter.value!,
      createdAt: DateTime.now(),
      medias: [
        ChatMedia(
          url: '',
          fileName: fileName,
          type: MediaType.image,
        ),
      ],
    );
    sendMessage(message);
    isAttachmentOpen.value = false;
  }

  void sendMessage(ChatMessage message) {
    print({
      'roomId': roomId,
      'user': chatter.toJson(),
      'text': message.text,
      'createdAt': DateTime.now().toUtc().toString(),
      if (message.medias?.isNotEmpty ?? false)
        'medias': [
          for (final ChatMedia media in message.medias!)
            {
              'fileName': media.fileName,
              'type': media.type.toString(),
            }
        ]
    });
    socket.emit('sentMessage', {
      'roomId': roomId,
      'user': chatter.toJson(),
      'text': message.text,
      'createdAt': DateTime.now().toUtc().toString(),
      if (message.medias?.isNotEmpty ?? false)
        'medias': [
          for (final ChatMedia media in message.medias!)
            {
              'fileName': media.fileName,
              'type': media.type.toString(),
            }
        ]
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
