import 'package:flutter/material.dart';
import 'package:video_sharing_app/pages/view_video/widgets/play_video/play_video_info.dart';
import 'package:video_sharing_app/pages/view_video/widgets/play_video/video_player.dart';

import '../../models/video_model.dart';

class PlayVideo extends StatelessWidget {
  const PlayVideo({super.key, required this.video});
  final Video video;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: VideoPlayer(videoUrl: video.videoUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: play_video_Info(video),
          )
        ],
      ),
    );
  }
}
