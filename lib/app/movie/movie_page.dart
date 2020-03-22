import 'package:flutter/material.dart';
import 'package:moviedb_flutter/app/models/movie_model.dart';

class MoviePage extends StatelessWidget {
  final MovieModel movie;
  final bool isTested;
  final String title;

  const MoviePage({
    Key key,
    this.title = "Movie",
    @required this.movie,
    this.isTested = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        title: Text(
          "Movie details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: isTested
                      ? null
                      : DecorationImage(
                          image: NetworkImage(
                            'http://image.tmdb.org/t/p/w185/${movie.posterPath}',
                          ),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                title: Text("Name"),
                subtitle: Text(movie.title),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                title: Text("Genre"),
                subtitle: Text(movie.genres),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                title: Text("Overview"),
                subtitle: Text(movie.overview),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
