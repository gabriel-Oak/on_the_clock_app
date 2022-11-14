import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:on_the_clock_app/pages/home/home_event.dart';
import 'package:on_the_clock_app/pages/home/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Future<SharedPreferences> prefs;
  final Dio dio;

  HomeBloc({required this.prefs, required this.dio}) : super(Started()) {
    on<Start>((event, emit) async {
      final SharedPreferences preferences = await prefs;
      final String? login = preferences.getString('login');
      final String? password = preferences.getString('password');
      final String? lastClock = preferences.getString('last_clock');

      emit(Loaded(
        login: login,
        password: password,
        lastClock: lastClock != null
            ? DateFormat('hh:mm - dd/MM/yyyy').format(DateTime.parse(lastClock))
            : null,
      ));
    });

    on<SendRequest>((event, emit) async {
      final nextState = (state as Loaded)
          .copyWith(login: event.login, password: event.password);
      try {
        emit(Processing());

        final res = await dio.post<String>('/register', data: {
          'login': event.login,
          'password': event.password,
          'loginType': '2',
        });
        final data = res.data.toString();
        final success = !data.startsWith("2");
        final message = data.substring(
            (success ? data.indexOf(":") : data.lastIndexOf("-")) + 1);

        emit(nextState.copyWith(
          message: message,
          lastClock: success
              ? DateFormat('hh:mm - dd/MM/yyyy').format(DateTime.now())
              : null,
        ));

        if (success) {
          final SharedPreferences preferences = await prefs;
          preferences.setString('login', event.login);
          preferences.setString('password', event.password);
          preferences.setString('last_clock', DateTime.now().toString());
        }
      } on DioError catch (e) {
        emit(nextState.copyWith(message: e.response!.data.toString()));
      } catch (e) {
        emit(nextState.copyWith(message: e.toString()));
      }
    });
  }
}
