import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/media_model.dart';

class FullScreenImage extends StatefulWidget {
  final MediaFile media;

  const FullScreenImage({
    super.key,
    required this.media,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  VideoPlayerController? _controller;
  @override

  void initState() {
    super.initState();

    if (widget.media.type == MediaType.video) {
      _controller = VideoPlayerController.file(
        File(widget.media.path),
      );

      _controller!
          .initialize()
          .then((_) {
        _controller!.play();
        setState(() {});
      });
    }  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: widget.media.type == MediaType.image
            ? InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.file(
            File(widget.media.path),
          ),
        )
            : (_controller != null &&
            _controller!.value.isInitialized)
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton:
      widget.media.type == MediaType.video &&
          _controller != null &&
          _controller!.value.isInitialized
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              _controller!.play();
            }
          });
        },
        child: Icon(
          _controller!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      )
          : null,
    );
  }
}
