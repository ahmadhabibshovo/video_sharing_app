import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_sharing_app/core/loaction/get_location.dart';
import 'package:video_sharing_app/pages/util/save_video.dart';
import 'package:video_sharing_app/pages/view_video/view_video.dart';

import '../../core/constant/constant.dart';

class PostVideo extends StatefulWidget {
  const PostVideo({super.key, required this.video, required this.thumbnail});
  final XFile video;
  final File thumbnail;
  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  void initState() {
    getCurrentLocation().then((value) {
      setState(() {
        loaded = true;
      });
    });
    super.initState();
  }

  Future getCurrentLocation() async {
    location = await getPlaceName();
  }

  String? location;
  String? _selectedCategory;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? const Scaffold(
            body: Center(
              child: const CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      widget.thumbnail,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Titile : "),
                        Expanded(
                            child: TextField(
                          controller: titleController,
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Description : "),
                        Expanded(
                            child: TextField(
                          controller: descriptionController,
                          maxLines: 4,
                        )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Location : "),
                      Text(location.toString()),
                    ],
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text('Select a category'),
                    items: videoCategories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newCategory) {
                      setState(() {
                        _selectedCategory = newCategory;
                      });
                    },
                  ),
                  FilledButton(
                      onPressed: () async {
                        EasyLoading.showSuccess('Post Success!');
                        String thumbnailUrl =
                            await StoreData().uploadThumbnail(widget.thumbnail);
                        await StoreData()
                            .saveVideoData(
                                thumbnailDownloadUrl: thumbnailUrl,
                                videoDownloadUrl: widget.video.path,
                                title: titleController.text,
                                description: descriptionController.text,
                                category: _selectedCategory!,
                                location: location!)
                            .then((value) {
                          EasyLoading.dismiss();

                          Get.offAll(VideoShowcase());
                        });
                      },
                      child: const Text("Post"))
                ]),
              ),
            ),
          );
  }
}
