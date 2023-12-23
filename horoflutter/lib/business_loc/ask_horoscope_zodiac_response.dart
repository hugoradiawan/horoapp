import 'package:horoflutter/business_loc/server_response.dart';

class AskHoroscopeZodiacResponse extends Jsonable {
  final String horoscope, zodiac;

  AskHoroscopeZodiacResponse(Map<String, dynamic> json)
      : horoscope = json['horoscope'] as String,
        zodiac = json['zodiac'] as String;

  @override
  Map<String, dynamic> toJson() => {
        'horoscope': horoscope,
        'zodiac': zodiac,
      };
}