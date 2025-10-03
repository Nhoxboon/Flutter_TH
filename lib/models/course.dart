class Course {
  final String title;
  final String creator;
  final int videoCount;
  final String bannerImage;
  final List<Video> videos;

  Course({
    required this.title,
    required this.creator,
    required this.videoCount,
    required this.bannerImage,
    required this.videos,
  });
}

class Video {
  final String title;
  final String duration;
  final bool isCompleted;

  Video({
    required this.title,
    required this.duration,
    this.isCompleted = false,
  });
}
