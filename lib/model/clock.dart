import 'package:equatable/equatable.dart';

class Clock extends Equatable {
  final String? login;
  final String? password;

  const Clock({required this.login, required this.password});

  Clock.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        password = json['password'];

  @override
  List<Object?> get props => [login, password];
}
