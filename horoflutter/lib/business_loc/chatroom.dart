import 'package:dash_chat_2/dash_chat_2.dart';

class ChatRoom {
  ChatRoom({
    this.id,
    required this.users,
    required this.messages,
  });

  final String? id;
  final List<String> users;
  final List<ChatMessage> messages;

  factory ChatRoom.fromJson(Map<String, dynamic> jsonData) => ChatRoom(
        id: jsonData['roomId'].toString(),
        users: jsonData['users'].cast<String>(),
        messages: jsonData['message']
            .map<ChatMessage>((e) => ChatMessage.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJsonWithoutId() => <String, dynamic>{
        'users': users,
        'message': messages.map((e) => e.toJson()).toList(),
      };
}
