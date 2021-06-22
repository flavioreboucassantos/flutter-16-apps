import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideosBloc videosBloc = BlocProvider.getBloc<VideosBloc>();
    final FavoriteBloc favoriteBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset('images/yt_logo_rgb_dark.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: favoriteBloc.outFav,
              initialData: Map<String, Video>(),
              builder: (context, snapshot) {
                Map<String, Video> data = snapshot.data ?? Map<String, Video>();
                return Text(data.length.toString());
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Favorites(),
                ),
              );
            },
            icon: Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              if (result != '' || result != null)
                videosBloc.inSearch.add(result);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<List<Video>>(
        stream: videosBloc.outVideos,
        builder: (context, snapshot) {
          if (snapshot.data is VideosLoading)
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          else if (snapshot.hasData) {
            List<Video> data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index < data.length)
                  return VideoTile(data[index]);
                else if (data.length == 0) return Container();

                videosBloc.inSearch.add(null);
                return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              },
            );
          } else
            return Container();
        },
      ),
    );
  }
}
