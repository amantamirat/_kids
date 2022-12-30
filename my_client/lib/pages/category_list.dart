import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/services/category_Service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Future<List<Category>?>? categoriesList;

  @override
  void initState() {
    super.initState();
    categoriesList = CategoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: loadCategories(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('add_category');
        },
        backgroundColor: Colors.green,
        tooltip: 'Apply Changes',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget loadCategories() {
    return FutureBuilder(
      future: categoriesList,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Category>?> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return displayCategories(snapshot.data);
            }
        }
      },
    );
  }

  Widget displayCategories(categories) {
    return categories.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.amber[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${categories[index].title}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  subtitle: Text("${categories[index].description}"),
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(categories[index].getImageURL())),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            context.goNamed('edit_category',
                                extra: categories[index]);
                          },
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Category'),
                                content: const Text('Are you sure, proceed?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await CategoryService.deleteCategory(
                                          categories[index].id)) {
                                        Fluttertoast.showToast(
                                            msg: 'Removed!',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.yellow);
                                        setState(() {
                                          
                                        });
                                        context.pop();
                                      }
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )
        : const Center(child: Text('No Categories Found!'));
  }
}
