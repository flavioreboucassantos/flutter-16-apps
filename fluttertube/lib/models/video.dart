class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video(this.id, this.title, this.thumb, this.channel);

  factory Video.fromJsonOfServer(Map<String, dynamic> json) {
    return Video(
      json['id']['videoId'],
      json['snippet']['title'],
      json['snippet']['thumbnails']['high']['url'],
      json['snippet']['channelTitle'],
    );
  }

  factory Video.fromJsonOfSharedPreferences(Map<String, dynamic> json) {
    return Video(
      json['videoId'],
      json['title'],
      json['thumb'],
      json['channel'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'videoId': id,
      'title': title,
      'thumb': thumb,
      'channel': channel,
    };
  }
}
