import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../../models/video_model.dart';

String formatTimeDifference(Duration difference) {
  int hours = difference.inHours;
  int minutes = difference.inMinutes % 60; // Get minutes within an hour
  return '$hours${hours > 1 ? 'h' : ''} ${minutes}m'; // Add optional 'h' for plural hours
}

Row play_video_Info(Video video) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const CircleAvatar(
        child: Icon(Icons.person),
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(video.location.split(',').last)
              ],
            ),
            ReadMoreText(
              video.description,
              trimLines: 2, // Number of lines visible initially
              colorClickableText: Colors.blue,
              trimMode: TrimMode.Line, // Expand based on lines
              moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("user name"),
                const Text("Views"),
                Text(
                    '${formatTimeDifference(DateTime.now().difference(video.timeStamp))}  ago'),
                Text(video.category)
              ],
            ),
          ],
        ),
      )
    ],
  );
}
