import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';


import 'movie.dart';
import 'movie_service.dart';
import 'movies_exception.dart';

final moviesFutureProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;

  final movieService = ref.watch(movieServiceProvider);
  final movies = await movieService.getMovies();
  return movies;
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Movies - Netflix'),
      ),
      body: watch(moviesFutureProvider).when(
        error: (e, s) {
          if (e is MoviesException) {
            return _ErrorBody(message: e.message);
          }
          return _ErrorBody(message: "Oops, something unexpected happened");
        },
        loading: () => Center(child: CircularProgressIndicator()),
        data: (movies) {
          return RefreshIndicator(
            onRefresh: () {
              return context.refresh(moviesFutureProvider);
            },
            child: GridView.extent(
              padding: EdgeInsets.all(16),
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: movies.map((movie) => _MovieBox(movie: movie)).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(moviesFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}

class _MovieBox extends StatefulWidget {
  final Movie movie;

  const _MovieBox({Key key, this.movie}) : super(key: key);

  @override
  __MovieBoxState createState() => __MovieBoxState();
}

class __MovieBoxState extends State<_MovieBox> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Image.network(
          widget.movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: widget.movie.title,date:  widget.movie.releaseDate.toString(),overView: widget.movie.overView.toString(),),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatefulWidget {
  final String text;
  final String date;
  final String overView;

  const _FrontBanner({
    Key key,
    @required this.text,
    @required this.date,
    @required this.overView,

  }) : super(key: key);

  @override
  __FrontBannerState createState() => __FrontBannerState();
}

class __FrontBannerState extends State<_FrontBanner> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 80,
          child: Column(
            children: [
              Text(
                widget.text,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.red.shade800),
                textAlign: TextAlign.center,
                maxLines: 1,

              ),
              Text(
                widget.date,
                style: TextStyle(fontFamily: "Cairo-Bold",fontSize: 12,color: Colors.white60),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              Text(
                widget.overView,
                style: TextStyle(fontFamily: "arlrdbd",fontSize: 10,color: Colors.red.shade100),
                textAlign: TextAlign.center,
               softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),



            ],
          ),
        ),
      ),
    );

  }

}

