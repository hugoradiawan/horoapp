class Profile {
  final String username;
  final String? horoscope, imageUrl, birthday, gender, displayName;
  final double? height, weight;

  Profile({
    required this.username,
    this.horoscope,
    this.imageUrl,
    this.birthday,
    this.displayName,
    this.gender,
    this.height,
    this.weight,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'horoscope': horoscope,
        'imageUrl': imageUrl,
        'birthday': birthday,
        'displayName': displayName,
        'gender': gender,
        'height': height,
        'weight': weight,
      };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        username: json['username'],
        horoscope: json['horoscope'],
        imageUrl: json['imageUrl'],
        birthday: json['birthday'],
        displayName: json['displayName'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
      );
}
