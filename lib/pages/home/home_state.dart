import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class Started extends HomeState {}

class Loaded extends HomeState {
  final String? login;
  final String? password;
  final String? message;

  const Loaded({this.login = '', this.password = '', this.message});

  Loaded copyWith({String? login, String? password, String? message}) => Loaded(
        login: login ?? this.login,
        password: password ?? this.password,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [login, password, message];
}

class Processing extends HomeState {}
