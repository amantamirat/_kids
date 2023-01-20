import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/util/my_extra_wrapper.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Menu { itemManage, itemSettings }

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Future<List<Category>?>? categoriesList;
  bool manageMode = false;
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
                } else if (item == Menu.itemManage) {
                  setState(
                    () => {manageMode = !manageMode},
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem<Menu>(
                      value: Menu.itemManage,
                      child: Text(manageMode ? 'View Mode' : 'Manage Mode'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemSettings,
                      child: Text('Settings'),
                    ),
                  ]),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: loadCategories(),
      floatingActionButton: manageMode
          ? FloatingActionButton(
              onPressed: () {
                context.goNamed('merge_category',
                    params: {Constants.editMode: false.toString()},
                    extra: Category());
              },
              backgroundColor: Colors.green,
              tooltip: 'Add New Category',
              child: const Icon(Icons.add),
            )
          : Container(),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    ElevatedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.refresh,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Referesh'),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            categoriesList = MyService.getCategories();
                          });
                        }),
                  ],
                ),
              );
            } else {
              if (snapshot.data!.isNotEmpty) {
                return manageMode
                    ? _displayCategoryList(snapshot.data!)
                    : _display(snapshot.data!);
              }
              return const Center(child: Text('No Category Data is Found!'));
            }
        }
      },
    );
  }

  Widget _displayCategoryList(List<Category> categories) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(8),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = categories.elementAt(index);
        return Container(
          color: Colors.amberAccent[index * 10],
          child: ListTile(
            title: Center(
                child: Text(
              "${category.title}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )),
            leading: GestureDetector(
              onTap: () {
                context.pushNamed('upload_image', extra: category.id);
              },
              child: CachedNetworkImage(
                imageUrl: Constants.getImageURL(category.id),
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            onTap: () {
              final extra = MyExtraWrapper(
                  data: category, editMode: false, manageMode: manageMode);
              GoRouter.of(context).pushNamed('types', extra: extra);
            },
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () {
                      GoRouter.of(context).pushNamed('merge_category',
                          params: {Constants.editMode: true.toString()},
                          extra: category);
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
                          content: Text(
                              'Are you sure, delete ${category.title} and its Contenet?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (await MyService.deleteModel(category)) {
                                  setState(() {
                                    categoriesList = MyService.getCategories();
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
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _display(List<Category> categories) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories.elementAt(index);
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
                    InkWell(
                      onTap: () {
                        final extra = MyExtraWrapper(
                            data: category,
                            editMode: false,
                            manageMode: manageMode);
                        GoRouter.of(context).pushNamed('types', extra: extra);
                      },
                      child: CachedNetworkImage(
                        imageUrl: Constants.getImageURL(category.id),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
                          InkWell(
                            onTap: () {
                              context.pushNamed('view_products', extra: type);
                            },
                            child: CachedNetworkImage(
                              imageUrl: Constants.getImageURL(type.id),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
