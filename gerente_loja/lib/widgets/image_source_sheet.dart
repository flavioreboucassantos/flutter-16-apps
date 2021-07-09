import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  static final ImagePicker _picker = ImagePicker();

  final void Function(File? image) onImageSelected;

  ImageSourceSheet(this.onImageSelected);

  Future<void> imageSelected(PickedFile? pickedFile) async {
    if (pickedFile != null) {
      File? croppedImage = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              final PickedFile? pickedFile =
                  await _picker.getImage(source: ImageSource.camera);
              imageSelected(pickedFile);
            },
            child: Text('Câmera'),
          ),
          TextButton(
            onPressed: () async {
              final PickedFile? pickedFile =
                  await _picker.getImage(source: ImageSource.gallery);
              imageSelected(pickedFile);
            },
            child: Text('Galeria'),
          ),
        ],
      ),
    );
  }
}
