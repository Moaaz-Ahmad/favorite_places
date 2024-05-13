import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key,required this.onpickImage});
  final void Function(File image) onpickImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _image = File(imageFile.path);
    });
    widget.onpickImage(_image!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color:Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          alignment: Alignment.center,
          child: _image != null
              ? GestureDetector(
                onTap:_takePicture,
                child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
              )
              : TextButton.icon(onPressed: _takePicture, icon: const Icon(Icons.camera), label: const Text('Take Picture'),),
        ),
      ],
    );
  }
}