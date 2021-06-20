import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc extends BlocBase {
  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();
  final StreamController<String?> _searchController =
      StreamController<String?>();

  final Api api = Api();
  final List<Video> videos = <Video>[];

  Stream<List<Video>> get outVideos => _videosController.stream;

  Sink<String?> get inSearch => _searchController.sink;

  VideosBloc() {
    _searchController.stream.listen(_search);
  }

  void _search(String? search) async {
    List<Video> videos = await api.search(search);
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
    super.dispose();
  }
}
