import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moviedb_flutter/app/models/movie_model.dart';
import 'package:moviedb_flutter/app/movie/movie_bloc.dart';
import 'package:moviedb_flutter/app/search/search_page.dart';
import 'package:moviedb_flutter/app/services/movie_service.dart';
import 'package:moviedb_flutter/app/widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  final MovieService movieService;
  final bool isTested;
  final String title;
  const HomePage(
      {Key key, this.title = "Home", this.isTested = false, this.movieService})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  MovieBloc _movieBloc;

  @override
  void initState() {
    _movieBloc = MovieBloc(widget.movieService ?? MovieService(Dio()));
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 3) {
      _movieBloc.setPage.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.red,
        title: Text(
          "Movies",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<List<MovieModel>>(
            stream: _movieBloc.getMovies,
            builder: (context, AsyncSnapshot<List<MovieModel>> snapshot) {
              return snapshot.hasData
                  ? Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => MovieCardWidget(
                          movie: snapshot.data[index],
                          isTest: widget.isTested,
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    _scrollController
      ..removeListener(scrollListener)
      ..dispose();
    super.dispose();
  }
}
