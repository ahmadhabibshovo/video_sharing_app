import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_sharing_app/models/video_model.dart';
import 'package:video_sharing_app/pages/view_video/widgets/video_video/select_category.dart';
import 'package:video_sharing_app/pages/view_video/widgets/video_video/thumbnail.dart';
import 'package:video_sharing_app/pages/view_video/widgets/video_video/video_info.dart';

import '../record_post_video/post_video.dart';

class VideoShowcase extends StatefulWidget {
  const VideoShowcase({super.key});

  @override
  State<VideoShowcase> createState() => _VideoShowcaseState();
}

class _VideoShowcaseState extends State<VideoShowcase> {
  final _searchController = TextEditingController();
  bool loaded = false;
  late final List<Video> videos;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> getAllData() async {
    final snapshot = await firestore.collection("videos").get();
    return snapshot;
  }

  Future getVideos() async {
    final snapshot = await getAllData();
    videos = snapshot.docs.map((e) => Video.fromFirestore(e)).toList();
  }

  @override
  void initState() {
    getVideos().then((value) {
      setState(() {
        loaded = true;
      });
    });
    super.initState();
  }

  String selected = "All";
  var _selectedTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton(
            padding: EdgeInsets.only(right: 30),
            hint: Text(Get.isDarkMode ? "Dark" : "Light"),
            value: _selectedTheme,
            items: [
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
            onChanged: (c) {
              setState(() {
                _selectedTheme = c;
                Get.changeThemeMode(c as ThemeMode);
              });
            },
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          )
        ],
      ),
      body: loaded
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Add a search icon or button outside the border of the search bar
                          // IconButton(
                          //   icon: const Icon(Icons.search),
                          //   onPressed: () {
                          //     setState(() {});
                          //   },
                          // ),
                          Expanded(
                            // Use a Material design search bar
                            child: TextField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                // Add a clear button to the search bar
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    }),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SelectCategory(),
                        Column(
                          children: videos.map((video) {
                            if (video.title.contains(_searchController.text)) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Thumbnail(
                                      video: video,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    video_Info(video),
                                  ],
                                ),
                              );
                            } else {
                              return const Visibility(
                                child: Text("Invisible"),
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: false,
                              );
                            }
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? cameraVideo =
              await picker.pickVideo(source: ImageSource.camera);
          final thumbnailFile =
              await VideoCompress.getFileThumbnail(cameraVideo!.path,
                  quality: 100, // default(100)
                  position: -1 // default(-1)
                  );
          Get.to(
            PostVideo(
              thumbnail: thumbnailFile,
              video: cameraVideo,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
