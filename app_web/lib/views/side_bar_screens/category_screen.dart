import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/views/side_bar_screens/image/pick_banner_image.dart';
import 'package:app_web/views/side_bar_screens/title/section_title.dart';
import 'package:flutter/material.dart';

import '../../global_variables.dart';
import './image/image_picker.dart';
import 'image/pick_image.dart';
import 'widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController categoryController = CategoryController();
  late String name;
  dynamic image;
  dynamic bannerImage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Categories"),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(color: Colors.grey),
            ),

            Row(
              children: [
                ImagePicker(
                  img: image,
                  name: "Category image",
                  backgroundColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) => name = value,
                      validator: (value) {
                        if (value!.isNotEmpty)
                          return null;
                        else
                          return "Please enter category name";
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Category Name",
                      ),
                    ),
                  ),
                ),

                TextButton(onPressed: () {}, child: Text("cancel")),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      categoryController.uploadCategory(
                        pickedImage: image,
                        pickedBanner: bannerImage,
                        name: name,
                        context: context,
                      );
                    }
                  },
                  child: Text("Save", style: TextStyle(color: Colors.white)),
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

            const Divider(color: Colors.grey),

            ImagePicker(
              img: bannerImage,
              name: "Category Banner",
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),

            PickBannerImage(
              onImageBannerPicked: (img) {
                setState(() {
                  bannerImage = img;
                });
              },
            ),

            const Divider(color: Colors.grey),

            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
