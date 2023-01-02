import 'dart:io';
import 'package:abdu_kids/services/category_Service.dart';
import 'package:abdu_kids/util/configuration.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class ImageUploader extends StatefulWidget {
  final String id;
  const ImageUploader({Key? key, required this.id}) : super(key: key);
  @override
  State<ImageUploader> createState() => _ImageUploader();
}

class _ImageUploader extends State<ImageUploader> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  Image? _remoteImage;
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    _remoteImage = Image.network(
      Configuration.getImageURL(widget.id),
      width: 200,
      height: 200,
      fit: BoxFit.scaleDown,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        "assets/images/No-Image-Placeholder.svg.png",
        width: 200,
        height: 200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("upload image")),
      body: imagePicker(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isImageSelected) {
            CategoryService.uploadImage(widget.id, _image!.path);
            context.pop();
          }
        },
        backgroundColor: Colors.green,
        tooltip: 'upload',
        child: const Icon(Icons.upload),
      ),
    ));
  }

  Widget imagePicker() {
    return Column(
      children: [
        SizedBox(
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  )
                : _remoteImage),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.image, size: 35.0),
                onPressed: () async {
                  final XFile? pickedImage =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _image = File(pickedImage.path);
                      if (_image != null) {
                        _isImageSelected = true;
                      }
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 35.0,
              width: 35.0,
              child: IconButton(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                icon: const Icon(Icons.camera, size: 35.0),
                onPressed: () async {
                  final XFile? pickedImage =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _image = File(pickedImage.path);
                      if (_image != null) {
                        _isImageSelected = true;
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
