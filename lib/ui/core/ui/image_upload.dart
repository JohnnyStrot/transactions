import 'package:transactions/data/services/api/api_service.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatelessWidget {
  ImageUpload({
    super.key,
    this.multiple = false,
    this.label = "Bild",
    required this.apiService,
    required this.type,
    required this.attr,
    required this.id,
    this.onUpload,
  });

  final ApiService apiService;
  final ImagePicker _picker = ImagePicker();
  final String label;
  final String type;
  final String attr;
  final int id;
  final bool multiple;
  final void Function({String? file, List<String>? files})? onUpload;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () async {
        var res = await _uploadImage();
        switch (res) {
          case Ok<({String? file, List<String>? files})>():
            if (onUpload != null) {
              onUpload!(file: res.value.file, files: res.value.files);
            }
          case Error<({String? file, List<String>? files})>():
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Upload fehlgeschlagen")));
            }
        }
      },
      label: Text(label),
      icon: Icon(Icons.image),
    );
  }

  Future<Result<({String? file, List<String>? files})>> _uploadImage() async {
    if (multiple) {
      Result<List<String>> res;
      var images = await _picker.pickMultiImage();
      debugPrint("Picked ${images.length} images");
      if (images.isNotEmpty) {
        res = await apiService.uploadImages(
          "image-upload/$type/$attr/$id",
          images,
        );
      } else {
        res = Result.error(Exception("No image selected"));
      }
      switch (res) {
        case Ok<List<String>>():
          debugPrint("Image uploaded");
          return Result.ok((files: res.value, file: null));
        case Error<List<String>>():
          debugPrint("Error uploading image");
          return Result.error(res.error);
      }
    } else {
      Result<String?> res;
      var img = await _picker.pickImage(source: ImageSource.gallery);
      debugPrint("Picked image ${img?.path.toString() ?? "null"}");
      if (img != null) {
        res = await apiService.uploadImage("image-upload/$type/$attr/$id", img);
      } else {
        res = Result.error(Exception("No image selected"));
      }
      switch (res) {
        case Ok<String?>():
          debugPrint("Image uploaded");
          return Result.ok((file: res.value, files: null));
        case Error<String?>():
          debugPrint("Error uploading image");
          return Result.error(res.error);
      }
    }
  }
}
