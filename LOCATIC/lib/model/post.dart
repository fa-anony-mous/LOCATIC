class Post {
  final String title;
  final String body;
  List<String> photos;
  int likes;

  Post(this.title, this.body, {this.photos = const [], this.likes = 0});
}
