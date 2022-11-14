import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_the_clock_app/pages/home/home_bloc.dart';
import 'package:on_the_clock_app/pages/home/home_content.dart';
import 'package:on_the_clock_app/pages/home/home_event.dart';
import 'package:on_the_clock_app/utils/interceptors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://on-the-clock-js.vercel.app/api'));

  HomePage({super.key}) {
    dio.interceptors.add(CustomInterceptors());
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => HomeBloc(
          prefs: SharedPreferences.getInstance(),
          dio: dio,
        )..add(Start()),
        child: HomeContent(),
      );
}
