import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class StoreData {
  Future<String> uploadVideo(String videoUrl) async {
    Reference ref = _storage.ref().child('videos/${DateTime.now()}.mp4');
    await ref.putFile(File(videoUrl));
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadThumbnail(File thumbnail) async {
    Reference ref = _storage.ref().child('thumbnail/${DateTime.now()}.jpg');
    await ref.putFile(thumbnail);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> saveVideoData(
      {required String thumbnailDownloadUrl,
      required String videoDownloadUrl,
      required String title,
      required String description,
      required String category,
      required String location}) async {
    await _fireStore.collection('videos').add({
      'thumbnailUrl': thumbnailDownloadUrl,
      'videoUrl': videoDownloadUrl,
      'timeStamp': FieldValue.serverTimestamp(),
      'title': title,
      'description': description,
      'category': category,
      'location': location,
    });
  }

  Future<MediaInfo> compressVideo(String path) async {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      path,

      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo!;
  }
}
