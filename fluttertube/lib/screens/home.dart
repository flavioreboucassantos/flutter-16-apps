import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: Text('0'),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<List<Video>>(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Video> data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return VideoTile(data[index]);
              },
            );
          } else
            return Container();
        },
      ),
    );
  }
}
