import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/pages/categories/category_merge.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryList extends MyModelPage {
  final List<Category> categories;
  const CategoryList({Key? key, required this.categories})
      : super(
            key: key,
            myList: categories,
            title: "ABDU KIDS",            
            editPage: PageNames.editCategory,
            nextPage: PageNames.types);
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends MyModelPageState<CategoryList> {
  late List<Category> _categories;
  @override
  void initState() {
    super.initState();
    if (widget.categories.isEmpty) {
      _categories = List.empty(growable: true);
    } else {
      _categories = widget.categories;
    }
  }

  @override
  void onCreatePressed() async {
    final Category? category = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CategoryMerge(editMode: false, selectedCategory: Category())));
    if (category != null) {
      setState(() {
        _categories.add(category);
      });
    }
  }

  @override
  Widget displayGrid() {
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
                                    GoRouter.of(context).pushNamed(
                                        PageNames.types,
                                        extra: category);
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
                    context.pushNamed(PageNames.products, extra: type);
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
                        color: Colors.white,
                        backgroundColor: Colors.grey)),
              ],
            ),
          );
        });
  }
}
