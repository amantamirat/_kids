import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/pages/categories/category_merge.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
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
  late List<Category> _categories = List.empty(growable: true);
  late bool _manageMode = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABDU KIDS'),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<Menu>(
              onSelected: (Menu item) async {
                if (item == Menu.itemSettings) {
                  GoRouter.of(context).pushNamed("settings");
                } else if (item == Menu.itemManage) {
                  setState(
                    () => {_manageMode = !_manageMode},
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem<Menu>(
                      value: Menu.itemManage,
                      child: Text(_manageMode ? 'View Mode' : 'Manage Mode'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemSettings,
                      child: Text('Settings'),
                    ),
                  ]),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _loadCategories(),
      floatingActionButton: _manageMode
          ? FloatingActionButton(
              onPressed: () async {
                final Category? category = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryMerge(
                            editMode: false, selectedCategory: Category())));
                if (category != null) {
                  setState(() {
                    _categories.add(category);
                  });
                }
              },
              backgroundColor: Colors.green,
              tooltip: 'Add New Category',
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }

  Widget _loadCategories() {
    return FutureBuilder(
      future: MyService.getCategories(),
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
                            Text('Try Again'),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            //categoriesList = MyService.getCategories();
                          });
                        }),
                  ],
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                _categories = snapshot.data!;
                return _manageMode ? _displayCategoryList() : _display();
              }
              return const Center(child: Text('No Category Data is Found!'));
            }
        }
      },
    );
  }

  Widget _displayCategoryList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(8),
      itemCount: _categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = _categories.elementAt(index);
        return Container(
          color: Colors.amberAccent[index * 10],
          child: ListTile(
            title: Center(
                child: Text(
              category.title!,
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
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            onTap: () {
              final extra = MyExtraWrapper(
                  data: category, editMode: false, manageMode: _manageMode);
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryMerge(
                                  editMode: true, selectedCategory: category)));
                    },
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      int? result = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) =>
                              DeleteDialog(model: category));
                      if (result == 0) {
                        setState(() {
                          _categories.remove(category);
                        });
                      }
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

  Widget _display() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: GridView.builder(
          itemCount: _categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final category = _categories.elementAt(index);
            return Card(
                color: Colors.amber,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                shadowColor: Colors.amber[index * 10],
                elevation: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
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
                                        manageMode: _manageMode);
                                    GoRouter.of(context)
                                        .pushNamed('types', extra: extra);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        Constants.getImageURL(category.id),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      Constants.noImageAssetPath,
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                Text(category.title!,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.amber)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: _typesView(category))
                  ],
                ));
          }),
    );
  }

  Widget _typesView(Category category) {
    return GridView.builder(
        itemCount: category.clothingTypes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final type = category.clothingTypes.elementAt(index);
          return Card(
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    context.pushNamed('view_products', extra: type);
                  },
                  child: CachedNetworkImage(
                    imageUrl: Constants.getImageURL(type.id),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      Constants.noImageAssetPath,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                Text("${type.type}",
                    style: const TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                        backgroundColor: Colors.amber)),
              ],
            ),
          );
        });
  }
}
