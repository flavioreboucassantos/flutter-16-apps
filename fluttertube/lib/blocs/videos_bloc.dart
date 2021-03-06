import 'dart:async';
import 'dart:collection';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosLoading extends ListBase<Video> {
  @override
  int length = 0;

  @override
  operator [](int index) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(int index, value) {
    // TODO: implement []=
  }
}

class VideosBloc extends BlocBase {
  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();
  final StreamController<String?> _searchController =
      StreamController<String?>();

  final Api api = Api();
  List<Video> videos = <Video>[];

  Stream<List<Video>> get outVideos => _videosController.stream;

  Sink<String?> get inSearch => _searchController.sink;

  VideosBloc() {
    _searchController.stream.listen(_search);
  }

  void _search(String? search) async {
    if (search == null) {
      videos += await api.nextPage();
    } else {
      _videosController.sink.add(VideosLoading());
      videos = await api.search(search);
    }
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
    super.dispose();
  }
}
