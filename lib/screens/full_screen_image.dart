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

  @override
  void initState() {
    super.initState();

    if (widget.media.type == MediaType.video) {
      _controller = VideoPlayerController.file(
        File(widget.media.path),
      );

      _controller!
        ..addListener(() {
          if (mounted) {
            setState(() {});
          }
        })
        ..initialize().then((_) {
          _controller!.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = d.inHours;
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    if (hours > 0) {
      return "${twoDigits(hours)}:$minutes:$seconds";
    }

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body:
      Center(
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
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.pink,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white24,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(
                      _controller!.value.position,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _formatDuration(
                      _controller!.value.duration,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: widget.media.type == MediaType.video &&
          _controller != null &&
          _controller!.value.isInitialized
          ? Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          backgroundColor: Colors.pink.shade50,
          foregroundColor: Colors.pink.shade400,
          elevation: 4,
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
        ),
      )
          : null,
    );
  }
}
