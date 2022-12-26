import 'dart:io';
import 'package:abdu_kids/model/category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoryMerge extends StatefulWidget {
  final bool editMode;
  final Category selectedCategory;
  const CategoryMerge(
      {Key? key, required this.editMode, required this.selectedCategory})
      : super(key: key);
  @override
  State<CategoryMerge> createState() => _CategoryMerge();
}

class _CategoryMerge extends State<CategoryMerge> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String appBarTitle = "Add Category";
    if (widget.editMode) {
      _titleController.text = widget.selectedCategory.title ?? '';
      _descriptionController.text = widget.selectedCategory.description ?? '';
      appBarTitle = "Edit Category";
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
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
                      controller: _titleController,
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
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Category Description")),
                ),
                imagePicker(),
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

  File? _image;
  ImagePicker picker = ImagePicker();

  Widget imagePicker() {
    return Column(
      children: [
        SizedBox(
            child: _image != null
                ? Image.file(_image!, width: 200, height: 200)
                : widget.editMode
                    ? Image.network(
                        widget.selectedCategory.getFullImageURL(),
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "assets/images/No-Image-Placeholder.svg.png",
                        width: 200,
                        height: 200,
                      )),
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
