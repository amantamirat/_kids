import 'dart:io';
import 'package:abdu_kids/services/image_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  CachedNetworkImage? _remoteImage;
  bool _isImageSelected = false;

  @override
  void initState() {
    super.initState();
    _remoteImage = CachedNetworkImage(
        imageUrl: Constants.getImageURL(widget.id),
        progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
        errorWidget: (context, url, error) => Image.asset(
              Constants.noImageAssetPath,
            ),
        imageBuilder: (context, imageProvider) => Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ));

    /*Image.network(
      Constants.getImageURL(widget.id),
      width: 200,
      height: 200,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        Constants.noImageAssetPath,
        width: 200,
        height: 200,
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("upload image")),
      body: imagePicker(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_isImageSelected) {
            bool uploded =
                await ImageService.uploadImage(widget.id, _image!.path);
            if (uploded) {
              await CachedNetworkImage.evictFromCache(
                      Constants.getImageURL(widget.id))
                  .then((value) {
                //ignore: avoid_print
                print('File removed');
              }).onError((error, stackTrace) {
                //ignore: avoid_print
                print(error);
              });

              context.pop();
            }
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
            const SizedBox(
              height: 20,
            ),
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
