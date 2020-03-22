import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'package:moviedb_flutter/app/models/movie_model.dart';

class MovieService extends Disposable {
  final _apiKey = DotEnv().env['api_key'];
  final Dio client;

  MovieService(this.client);

  Future<List<MovieModel>> search(String query, int page) async {
    try {
      final res = await client.get(
          "https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&language=en-US&query=$query&page=$page&include_adult=false");
      final result = List<MovieModel>.from(
        res.data['results'].map(
          (movie) => MovieModel.fromJson(movie),
        ),
      );
      return result;
    } on DioError catch (e) {
      print(e.response.data);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getUpcomingMovies(int page) async {
    try {
      final res = await client.get(
          "https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey&language=en-US&page=$page");

      final result = List<MovieModel>.from(
        res.data['results'].map(
          (movie) => MovieModel.fromJson(movie),
        ),
      );

      return result;
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  @override
  void dispose() {}
}
