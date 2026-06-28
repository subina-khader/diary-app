import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoPath;

  const VideoThumbnailWidget({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoThumbnailWidget> createState() =>
      _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState
    extends State<VideoThumbnailWidget> {
  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
    loadThumbnail();
  }

  Future<void> loadThumbnail() async {
    final path = await VideoThumbnail.thumbnailFile(
      video: widget.videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 80,
    );

    if (mounted) {
      setState(() {
        thumbnailPath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (thumbnailPath == null) {
      return Container(
        color: Colors.black12,
      );
    }

    return Image.file(
      File(thumbnailPath!),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}