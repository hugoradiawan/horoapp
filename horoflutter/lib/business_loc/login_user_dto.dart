class LoginUserDto {
  String usernameOrEmail, password;

  LoginUserDto({
    required this.usernameOrEmail,
    required this.password,
  });

  LoginUserDto.init()
      : usernameOrEmail = '',
        password = '';

  Map<String, dynamic> get toJson => {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      };
}