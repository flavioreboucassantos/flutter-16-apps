import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc extends BlocBase {
  Map<String, Video> _favorites = Map<String, Video>();

  final BehaviorSubject<Map<String, Video>> _favController =
      BehaviorSubject<Map<String, Video>>();

  Stream<Map<String, Video>> get outFav => _favController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains('favorites')) {
        _favorites =
            (json.decode(prefs.getString('favorites') ?? '') as Map).map(
          (key, value) =>
              MapEntry(key, Video.fromJsonOfSharedPreferences(value)),
        );
        _favController.add(_favorites);
      }
    });
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('favorites', json.encode(_favorites));
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id))
      _favorites.remove(video.id);
    else
      _favorites[video.id] = video;

    _favController.sink.add(_favorites);

    _saveFav();
  }

  @override
  void dispose() {
    _favController.close();
    super.dispose();
  }
}
