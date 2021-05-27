import 'dart:convert';

class Movie {
  String title;
  String posterPath;
  String releaseDate;
  String overView;

  Movie({
    this.title,
    this.posterPath,
    this.releaseDate,
    this.overView
  });

  String get fullImageUrl => 'https://image.tmdb.org/t/p/w200$posterPath';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poster_path': posterPath,
      'release_date':releaseDate,
      'overview':overView,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Movie(
      title: map['title'],
      posterPath: map['poster_path'],
      releaseDate: map['release_date'],
      overView: map['overview'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
