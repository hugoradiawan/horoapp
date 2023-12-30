class Chat {
  final List<String> name;
  final List<String> profileId;
  final String lastMesage;

  Chat({
    required this.name,
    required this.profileId,
    required this.lastMesage,
  });

  factory Chat.fromJson(Map<String, dynamic> jsonData) => Chat(
        name: jsonData['name'].cast<String>(),
        profileId: jsonData['profileId'].cast<String>(),
        lastMesage: jsonData['lastMesage'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'profileId': profileId,
        'lastMesage': lastMesage,
      };
}
