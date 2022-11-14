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
  final String? lastClock;

  const Loaded(
      {this.login = '', this.password = '', this.message, this.lastClock = ''});

  Loaded copyWith(
          {String? login,
          String? password,
          String? message,
          String? lastClock}) =>
      Loaded(
        login: login ?? this.login,
        password: password ?? this.password,
        message: message ?? this.message,
        lastClock: lastClock ?? this.lastClock,
      );

  @override
  List<Object?> get props => [login, password, message, lastClock];
}

class Processing extends HomeState {}
