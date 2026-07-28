import 'package:app_web/controllers/banner_controller.dart';
import 'package:app_web/views/side_bar_screens/image/pick_image.dart';
import 'package:app_web/views/side_bar_screens/title/section_title.dart';
import 'package:app_web/views/side_bar_screens/widgets/banner_widget.dart';
import 'package:flutter/material.dart';

import './image/image_picker.dart';

class UploadBannerScreen extends StatefulWidget {
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  final BannerController bannerController = BannerController();
  dynamic image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: "Banners"),

        Divider(color: Colors.grey, thickness: 2),

        Row(
          children: [
            ImagePicker(
              img: image,
              name: "Category image",
              backgroundColor: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  await bannerController.uploadBanner(
                    pickedImage: image,
                    context: context,
                  );
                },
                child: Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        PickImage(
          onImagePicked: (img) {
            setState(() {
              image = img;
            });
          },
        ),

        Divider(color: Colors.grey),

        BannerWidget(),
      ],
    );
  }
}
