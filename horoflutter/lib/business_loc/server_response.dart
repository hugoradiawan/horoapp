class ServerResponse<T> {
  final bool isOk;
  final int? errorCode;
  final String? message;
  final T? data;

  ServerResponse({
    required this.isOk,
    required this.errorCode,
    this.message,
    this.data,
  });

  factory ServerResponse.fromJson(dynamic json) => ServerResponse(
        isOk: json['isOk'],
        errorCode: int.tryParse(json['errorCode'].toString()),
        message: json['message'],
        data: json['data'],
      );

  Map<String, dynamic> get toJson => {
        'isOk': isOk,
        'errorCode': errorCode,
        'message': message,
        'data': data,
      };
}