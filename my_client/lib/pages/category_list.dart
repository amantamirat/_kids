import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/services/category_Service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    super.initState();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed('add_category');
        },
        backgroundColor: Colors.green,
        label: const Text("Add Category"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget loadCategories() {
    return FutureBuilder(
      future: CategoryService.getCategories(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Category>?> model,
      ) {
        if (model.hasData) {
          return displayCategories(model.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget displayCategories(categories) {
    return categories.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                color: Colors.amber[index * 10],
                child: ListTile(
                  title: Center(child: Text('${categories[index].title}')),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          CategoryService.getFullImageURL(
                              '${categories[index].imageURL}'))),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {                                                       
                            context.goNamed('edit_category', extra: categories[index]);
                          },
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            Navigator.pop(context);
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
