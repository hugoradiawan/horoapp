class CreateUserDto {
  String username, password, email;

  CreateUserDto({
    required this.username,
    required this.password,
    required this.email,
  });

  CreateUserDto.init()
      : username = '',
        password = '',
        email = '';

  Map<String, dynamic> get toJson => {
        'username': username,
        'password': password,
        'email': email,
      };
}