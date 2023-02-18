import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/categories/merge_category.dart';
import 'package:abdu_kids/pages/my_page.dart';
import 'package:abdu_kids/pages/util/my_grid_view.dart';
import 'package:abdu_kids/pages/util/my_navigation_drawer.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDashboard extends MyPage {
  final User? loggedInUser;
  MyDashboard({Key? key, required this.loggedInUser})
      : super(key: key, wrapper: ExtraWrapper(loggedInUser, null));
  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends MyPageState<MyDashboard> {
  late Future<List<Category>?> _myFuture;
  @override
  void initState() {
    super.initState();
    _myFuture = MyService.getCategories();
  }

  @override
  void onCreatePressed() async {
    final Category? category = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MergeCategory(
                  wrapper: ExtraWrapper(loggedInUser, Category()),
                )));
    if (category != null) {
      setState(() {
        myList!.add(category);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abdu Kids"),
        actions: prepareActions(context),
      ),
      drawer: MyNavigationDrawer(loggedInUser: widget.loggedInUser),
      body: !manageMode ? displayGrid() : displayList(),
      floatingActionButton: floatingActionButton(),
    );
  }

  @override
  Widget displayGrid() {
    return FutureBuilder(
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
              if (snapshot.hasData) {
                myList = snapshot.data;
                return manageMode
                    ? displayList()
                    : _displayGrid(snapshot.data!);
              }
              return const Center(child: Text("No Category Data Found!"));
            }
        }
      },
    );
  }

  Widget _displayGrid(List<Category> categories) {
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
                                        PageNames.myGridPage,
                                        extra: ExtraWrapper(
                                            widget.loggedInUser, category));
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
                    Expanded(
                        child: MyGridView(
                      myList: category.clothingTypes,
                      isSubGrid: true,
                    ))
                  ],
                ));
          }),
    );
  }
}
