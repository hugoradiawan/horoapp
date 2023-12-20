import 'package:horoflutter/business_loc/server_response.dart';

class Profile extends Jsonable {
  String? username, horoscope, zodiac, imageUrl, birthday, displayName;
  int? height, weight;
  bool? gender;

  Profile({
    this.username,
    this.horoscope,
    this.imageUrl,
    this.birthday,
    this.displayName,
    this.zodiac,
    this.gender,
    this.height,
    this.weight,
  });

  @override
  Map<String, dynamic> toJson({bool withUsername = true}) => {
        if (withUsername && username != null) 'username': username,
        if (horoscope != null) 'horoscope': horoscope,
        if (zodiac != null) 'zodiac': zodiac,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (birthday != null) 'birthday': birthday,
        if (displayName != null) 'name': displayName,
        if (gender != null) 'gender': gender,
        if (height != null) 'heightInCm': height,
        if (weight != null) 'weightInKg': weight,
      };

  @override
  Profile? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Profile(
      username: json['username'],
      horoscope: json['horoscope'],
      zodiac: json['zodiac'],
      imageUrl: json['imageUrl'],
      birthday: json['birthday'],
      displayName: json['name'],
      gender: json['gender'],
      height: int.tryParse(json['heightInCm'].toString()),
      weight: int.tryParse(json['weightInKg'].toString()),
    );
  }
}
