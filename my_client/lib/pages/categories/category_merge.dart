import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

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
                  child: TextFormField(
                    controller: _titleController,
                    decoration:
                        const InputDecoration(hintText: "Category Title"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter category title';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                      maxLines: null,
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Category Description")),
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final category = widget.selectedCategory;
                        category.title = _titleController.text;
                        category.description = _descriptionController.text;

                        /*ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Processing Request...')),
                        );*/
                        if (await MyService.saveItem(
                            category, widget.editMode)) {
                          Fluttertoast.showToast(
                              msg: 'Saved',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                          context.pop();
                        }
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
