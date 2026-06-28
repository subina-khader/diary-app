class MediaFile {
  final String path;
  final MediaType type;

  MediaFile({
    required this.path,
    required this.type,
  });
  Map<String, dynamic> toJson() {
    return {
      "path": path,
      "type": type.name,
    };
  }

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      path: json["path"],
      type: json["type"] == "video"
          ? MediaType.video
          : MediaType.image,
    );
  }
}

enum MediaType {
  image,
  video,
}