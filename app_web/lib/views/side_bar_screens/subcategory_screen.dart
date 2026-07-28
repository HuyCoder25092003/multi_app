import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/views/side_bar_screens/title/section_title.dart';
import 'package:app_web/views/side_bar_screens/widgets/subcategory_widget.dart';
import 'package:flutter/material.dart';

import '../../global_variables.dart';
import '../../models/caetgory.dart';
import 'image/image_picker.dart';
import 'image/pick_image.dart';

class SubcategoryScreen extends StatefulWidget {
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final SubcategoryController subcategoryController = SubcategoryController();
  late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  dynamic image;
  late String name;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Subcategories"),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(color: Colors.grey),
            ),

            FutureBuilder(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Category"));
                } else {
                  return DropdownButton<Category>(
                    value: selectedCategory,
                    hint: const Text("Select Category"),
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                      print(selectedCategory!.name);
                    },
                  );
                }
              },
            ),

            Row(
              children: [
                ImagePicker(
                  img: image,
                  name: "Subcategory image",
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
                          return "Please enter subcategory name";
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Subcategory Name",
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await subcategoryController.uploadSubcategory(
                        categoryId: selectedCategory!.id,
                        categoryName: selectedCategory!.name,
                        context: context,
                        pickedImage: image,
                        subCategoryName: name,
                      );
                      setState(() {
                        formKey.currentState!.reset();
                        image = null;
                      });
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

            Divider(color: Colors.grey),

            SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
