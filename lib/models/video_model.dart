import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id; // Document ID
  final String title;
  final String description;
  final String location;
  final String thumbnailUrl;
  final String videoUrl;
  final String category; // Always "Comedy" in this case
  final DateTime timeStamp;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.category,
    required this.timeStamp,
  });

  factory Video.fromFirestore(DocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Video(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      location: data['location'],
      thumbnailUrl: data['thumbnailUrl'],
      videoUrl: data['videoUrl'],
      category: data['category'] ?? "Comedy", // Set default if missing
      timeStamp: data['timeStamp'].toDate(),
    );
  }
}
