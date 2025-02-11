// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoContainer extends StatefulWidget {
  final String videoUrl;
  const VideoContainer({super.key, required this.videoUrl});

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  late VideoPlayerController controller;
  bool isIntilized = false;

  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          isIntilized = true;
          controller.setLooping(true);
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isIntilized
        ? Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    )),
              ],
            ),
          )
        : Container(
            child: const Center(child: CircularProgressIndicator()),
          );
  }
}
