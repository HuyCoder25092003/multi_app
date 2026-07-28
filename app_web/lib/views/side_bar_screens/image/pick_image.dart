import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickImage extends StatelessWidget {
  final String buttonText;
  final ValueChanged<dynamic> onImagePicked;
  const PickImage({
    super.key,
    this.buttonText = "Pick Image",
    required this.onImagePicked,
  });

  pickImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    onImagePicked(result?.files.first.bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(onPressed: pickImage, child: Text(buttonText)),
    );
    ;
  }
}
