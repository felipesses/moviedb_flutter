import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moviedb_flutter/app/models/movie_model.dart';
import 'package:moviedb_flutter/app/pages/search/search_bloc.dart';
import 'package:moviedb_flutter/app/services/movie_service.dart';
import 'package:moviedb_flutter/app/widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  final MovieService movieService;
  final bool isTested;

  final String title;
  const SearchPage(
      {Key key,
      this.title = "Search",
      this.isTested = false,
      this.movieService})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBloc _searchBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    _searchBloc = SearchBloc(
      widget.movieService ??
          MovieService(
            Dio(),
          ),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 3) {
      _searchBloc.setPage.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Movies",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: Colors.black,
              ),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hoverColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: Colors.red),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
              onChanged: _searchBloc.setQuery.add,
            ),
          ),
          StreamBuilder<List<MovieModel>>(
            stream: _searchBloc.getResults,
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
                  : Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    _scrollController
      ..removeListener(scrollListener)
      ..dispose();
    super.dispose();
  }
}
