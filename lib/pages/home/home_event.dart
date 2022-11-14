import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent([List props = const []]) : super();
}

class Start extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class SendRequest extends HomeEvent {
  final String login;
  final String password;

  const SendRequest({required this.login, required this.password}) : super();

  @override
  List<Object?> get props => [login, password];
}
