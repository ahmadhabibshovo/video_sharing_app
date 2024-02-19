import 'package:flutter/material.dart';
import 'package:video_sharing_app/pages/view_video/play_video.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({
    super.key,
    required this.video,
  });
  final video;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayVideo(
                      video: video,
                    )));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            video.thumbnailUrl,
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: 250,
          ),
          const Icon(
            Icons.play_circle_outline,
            size: 100,
          ),
        ],
      ),
    );
  }
}
