class ServerResponse<T extends Jsonable> {
  final bool? isOk;
  final int? errorCode;
  final String? message;
  final T? data;

  ServerResponse({
    this.isOk,
    this.errorCode,
    this.message,
    this.data,
  });

  factory ServerResponse.fromJson(dynamic json,
      {T Function(Map<String, dynamic>)? fromJson}) {
    if (json == null) return ServerResponse();
    return ServerResponse(
      isOk: json['isOk'],
      errorCode: int.tryParse(json['errorCode'].toString()),
      message: json['message'],
      data: fromJson != null ? fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> get toJson => {
        'isOk': isOk,
        'errorCode': errorCode,
        'message': message,
        'data': data?.toJson(),
      };
}

abstract class Jsonable<T> {
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  T fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
