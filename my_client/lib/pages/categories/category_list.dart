import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Menu { itemSettings }

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
    categoriesList = MyService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABDU KIDS'),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<Menu>(
              onSelected: (Menu item) {
                if (item == Menu.itemSettings) {
                  context.pushNamed('settings');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    const PopupMenuItem<Menu>(
                      value: Menu.itemSettings,
                      child: Text('Settings'),
                    ),
                  ]),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: loadCategories(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_category');
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
              return _display(snapshot.data);
            }
        }
      },
    );
  }

  Widget _display(List<Category>? categories) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: categories?.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories!.elementAt(index);
          return SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? (MediaQuery.of(context).size.height / 3)
                : (MediaQuery.of(context).size.height / 1.5),
            width: MediaQuery.of(context).size.width - 3,
            child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                shadowColor: Colors.amber[index * 10],
                elevation: 8,
                child: _displayCategory(category)),
          );
        },
      ),
    );
  }

  Widget _displayCategory(Category category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: MediaQuery.of(context).orientation == Orientation.portrait
              ? 2
              : 1,
          child: Card(
              child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Ink.image(
                      image: NetworkImage(Constants.getImageURL(category.id)),
                      fit: BoxFit.fill,
                      onImageError: (exception, stackTrace) => {
                        Image.asset(Constants.noImageAssetPath,
                            fit: BoxFit.fill)
                      },
                      child: InkWell(
                        onTap: () {
                          context.pushNamed('types', extra: category);
                        },
                      ),
                    ),
                    Text(
                      "${category.title}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 24,
                          backgroundColor: Colors.amber),
                    )
                  ],
                ),
              ),
              //const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(2).copyWith(bottom: 0),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      context.pushNamed('upload_image',
                          extra: category.id);
                    },
                    child: CircleAvatar(                    
                        backgroundImage: NetworkImage(
                            Constants.getImageURL(category.id))),
                  ),
                  title: Center(
                    child: Text(
                      "${category.clothingTypes.length} types",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  onTap: () {
                    //context.pushNamed('types', extra: category);
                  },
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            context.goNamed('edit_category', extra: category);
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
                                      if (await MyService.deleteModel(
                                          category)) {
                                        setState(() {
                                          categoriesList =
                                              MyService.getCategories();
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
              ),
            ],
          )),
        ),
        Expanded(
          child: SizedBox(
            child: GridView.builder(
                itemCount: category.clothingTypes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final type = category.clothingTypes.elementAt(index);
                  return SizedBox(
                    //height: (MediaQuery.of(context).size.height * 0.5),
                    child: Card(
                      child: Stack(
                        children: [
                          Ink.image(
                            image: NetworkImage(Constants.getImageURL(type.id)),
                            fit: BoxFit.fill,
                            onImageError: (exception, stackTrace) => {
                              Image.asset(Constants.noImageAssetPath,
                                  fit: BoxFit.fill)
                            },
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('view_products', extra: type);
                              },
                            ),
                          ),
                          Text("${type.type}",
                              style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                  backgroundColor: Colors.amber)),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
