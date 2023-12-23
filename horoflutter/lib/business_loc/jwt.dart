import 'package:horoflutter/business_loc/server_response.dart';

class Jwt extends Jsonable {
  final String accessToken;

  Jwt(Map<String, dynamic> json) : accessToken = json['accessToken'] as String;

  @override
  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
      };
}