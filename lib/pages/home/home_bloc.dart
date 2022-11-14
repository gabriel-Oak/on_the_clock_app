import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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

      emit(Loaded(login: login, password: password));
    });

    on<SendRequest>((event, emit) async {
      emit(Processing());
      final nextState = (state as Loaded)
          .copyWith(login: event.login, password: event.password);

      try {
        final res = await dio.post<String>('/register', data: {
          'login': event.login,
          'password': event.password,
        });

        print(res.data);
        emit(nextState.copyWith(message: res.data));

        final SharedPreferences preferences = await prefs;
        if (res.data?[0] == '1') {
          preferences.setString('login', event.login);
          preferences.setString('password', event.password);
        }
      } on DioError {
        print('Error no dio');
        emit(nextState.copyWith(message: 'Error no DIO'));
      } catch (e) {
        print(e);
        emit(nextState.copyWith(message: e.toString()));
      }
    });
  }
}
