class Video {
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video(this.id, this.title, this.thumb, this.channel);

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      json['id']['videoId'],
      json['snippet']['title'],
      json['snippet']['thumbnails']['high']['url'],
      json['snippet']['channelTitle'],
    );
  }
}
