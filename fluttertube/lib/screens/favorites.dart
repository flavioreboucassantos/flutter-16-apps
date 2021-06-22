import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: favoriteBloc.outFav,
        initialData: Map<String, Video>(),
        builder: (context, snapshot) {
          Map<String, Video> data = snapshot.data ?? Map<String, Video>();
          List<Video> videos = data.values.toList(growable: false);
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              Video v = videos[index];
              return InkWell(
                onTap: () {
                  final YoutubePlayerController _controller =
                      YoutubePlayerController(
                    initialVideoId: v.id,
                    flags: YoutubePlayerFlags(
                      isLive: true,
                    ),
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => YoutubePlayer(
                        controller: _controller,
                        liveUIColor: Colors.white38,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  favoriteBloc.toggleFavorite(v);
                },
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      child: Image.network(v.thumb),
                    ),
                    Expanded(
                      child: Text(
                        v.title,
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
