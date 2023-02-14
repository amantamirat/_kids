import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/util/my_navigation_drawer.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:abdu_kids/util/constants.dart';

class Dashboard extends StatefulWidget {
  final User? loggedInUser;
  const Dashboard({Key? key, this.loggedInUser}) : super(key: key);
  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  late Future<List<Category>?> _myFuture;
  @override
  void initState() {
    super.initState();
    _myFuture = MyService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Abdu Kids")),
      drawer: MyNavigationDrawer(loggedInUser: widget.loggedInUser),
      body: FutureBuilder(
        future: _myFuture,
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
                    ],
                  ),
                );
              } else {
                return !snapshot.hasData
                    ? const Center(child: Text("No Categories Found!"))
                    : displayGrid(snapshot.data!);
              }
          }
        },
      ),
    );
  }

  Widget displayGrid(List<Category> categories) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final category = categories.elementAt(index);
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
