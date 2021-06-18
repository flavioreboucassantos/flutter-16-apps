import 'dart:convert';

import 'api_key.dart';
import 'package:http/http.dart' as http;

import 'models/video.dart';

class Api {
  void search(String search) async {
    http.Response response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search'
        '&type=video&key=$API_KEY&maxResults=10'));
    decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      dynamic decoded = json.decode(response.body);

      List<Video> videos = decoded['items']
          .map<Video>((data) => Video.fromJson(data))
          .toList(growable: false);

      return videos;
    }
    throw Exception('Failed to load vídeos');
  }
}
