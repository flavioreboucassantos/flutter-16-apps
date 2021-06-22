import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc bloc = BlocProvider.getBloc<FavoriteBloc>();

    return GestureDetector(
      onTap: () {
        final YoutubePlayerController _controller = YoutubePlayerController(
          initialVideoId: video.id,
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text(
                          video.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text(
                          video.channel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: bloc.outFav,
                  initialData: Map<String, Video>(),
                  builder: (context, snapshot) {
                    Map<String, Video> data =
                        snapshot.data ?? Map<String, Video>();
                    return IconButton(
                      onPressed: () {
                        bloc.toggleFavorite(video);
                      },
                      icon: Icon(data.containsKey(video.id)
                          ? Icons.star
                          : Icons.star_border),
                      color: Colors.white,
                      iconSize: 30,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
