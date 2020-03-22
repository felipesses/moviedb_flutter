import 'package:moviedb_flutter/app/search/search_bloc.dart';
import 'package:moviedb_flutter/app/services/movie_service.dart';
import 'package:moviedb_flutter/app/app_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:moviedb_flutter/app/app_widget.dart';
import 'package:moviedb_flutter/app/home/home_module.dart';
import 'package:dio/dio.dart';
import 'package:moviedb_flutter/app/movie/movie_bloc.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => SearchBloc(AppModule.to.get<MovieService>())),
        Bind((i) => MovieService(i.get<Dio>())),
        Bind((i) => MovieBloc(AppModule.to.get<MovieService>())),
        Bind((i) => AppBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, module: HomeModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
