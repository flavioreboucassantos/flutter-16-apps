import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideosBloc bloc = BlocProvider.getBloc<VideosBloc>();

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
              bloc.inSearch.add(result);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<List<Video>>(
        stream: bloc.outVideos,
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

                bloc.inSearch.add(null);
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
