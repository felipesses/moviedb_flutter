import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:moviedb_flutter/app/models/movie_model.dart';
import 'package:moviedb_flutter/app/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';

class MovieBloc extends BlocBase {
  final MovieService moviesService;

  final _page = BehaviorSubject<int>();
  final _upcomingPage = BehaviorSubject<int>();

  Stream<List<MovieModel>> _upcomingMovies;

  Sink get setPage => _upcomingPage.sink;
  Stream<List<MovieModel>> get getMovies => _upcomingMovies;

  MovieBloc(this.moviesService) {
    _upcomingMovies = _upcomingPage
        .startWith(0)
        .mapTo(1)
        .scan((acc, curr, i) => acc + curr, 0)
        .asyncMap(
          (i) => moviesService.getUpcomingMovies(i),
        )
        .scan<List<MovieModel>>(
            (acc, curr, i) => acc..addAll(List.from(curr)), []);
  }

  void dispose() {
    _page.close();
    _upcomingPage.close();
  }
}
