import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickBannerImage extends StatelessWidget {
  final String buttonText;
  final ValueChanged<dynamic> onImageBannerPicked;
  const PickBannerImage({
    super.key,
    this.buttonText = "Pick Image",
    required this.onImageBannerPicked,
  });

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    onImageBannerPicked(result?.files.first.bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: pickBannerImage,
        child: Text(buttonText),
      ),
    );
  }
}
