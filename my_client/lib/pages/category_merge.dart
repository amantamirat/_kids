import 'dart:io';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/services/category_Service.dart';
import 'package:abdu_kids/util/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoryMerge extends StatelessWidget {
  final Category? category;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  CategoryMerge({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: category != null
              ? const Text('Edit Category')
              : const Text('Add Category')),
      body: Form(key: globalFormKey, child: categoryForm()),
    ));
  }

  Widget categoryForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextField(
                      controller: refreshController(_titleController),
                      decoration:
                          const InputDecoration(hintText: "Category Title")),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextField(
                      maxLines: null,
                      controller: refreshController(_descriptionController),
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Category Description")),
                ),
                ImagePickerHandler(currentImage: selectedImage()),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () {
                      final category = Category(
                          title: _titleController.text,
                          description: _descriptionController.text);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextEditingController refreshController(TextEditingController controller) {
    if (category != null) {
      if (controller == _titleController) {
        controller.text = category?.title ?? '';
      } else if (controller == _descriptionController) {
        controller.text = category?.description ?? '';
      }
    }
    return controller;
  }

  Image selectedImage() {
    Image img = Config.NoImagePlaceHolder;
    if (category != null) {
      img = Image.network(
        CategoryService.getFullImageURL('${category!.imageURL}'),
        width: 200,
        height: 200,
        fit: BoxFit.fill,
      );
    }
    return img;
  }
}

class ImagePickerHandler extends StatefulWidget {
  final Image currentImage;
  const ImagePickerHandler({Key? key, required this.currentImage})
      : super(key: key);
  @override
  State<ImagePickerHandler> createState() => _ImagePickerHandler();
}

class _ImagePickerHandler extends State<ImagePickerHandler> {
  File? _image;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            child: _image != null
                ? Image.file(_image!, fit: BoxFit.cover)
                : widget.currentImage),
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
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _image = File(pickedImage.path);
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
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _image = File(pickedImage.path);
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
