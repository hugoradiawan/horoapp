import 'package:horoflutter/business_loc/server_response.dart';

class Profile extends Jsonable {
  String? username, horoscope, zodiac, birthday, displayName, id, userId;
  int? height, weight;
  bool? gender;
  List<String>? interests;

  Profile({
    this.username,
    this.horoscope,
    this.birthday,
    this.displayName,
    this.zodiac,
    this.gender,
    this.height,
    this.userId,
    this.weight,
    this.id,
    this.interests,
  });

  @override
  Map<String, dynamic> toJson({bool withUsername = true}) => {
        if (withUsername && username != null) 'username': username,
        if (userId != null) 'userId': userId,
        if (horoscope != null) 'horoscope': horoscope,
        if (zodiac != null) 'zodiac': zodiac,
        if (birthday != null) 'birthday': birthday,
        if (displayName != null) 'name': displayName,
        if (gender != null) 'gender': gender,
        if (height != null) 'heightInCm': height,
        if (weight != null) 'weightInKg': weight,
        if (id != null) 'pId': id,
        if (interests != null) 'interests': interests,
        if (id != null) '_id': id,
      };

  bool isEmpty() =>
      horoscope == null ||
      zodiac == null ||
      birthday == null ||
      displayName == null ||
      height == null ||
      weight == null;

  @override
  Profile? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Profile(
      username: json['username'],
      userId: json['userId'],
      horoscope: json['horoscope'],
      zodiac: json['zodiac'],
      birthday: json['birthday'],
      displayName: json['name'],
      gender: json['gender'],
      height: int.tryParse(json['heightInCm'].toString()),
      weight: int.tryParse(json['weightInKg'].toString()),
      id: json['pId'] ?? json['_id'],
      interests: json['interests'] == null
          ? null
          : List<String>.from(json['interests']),
    );
  }
}
