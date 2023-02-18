import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/util/my_grid_view.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

abstract class MyPage extends StatefulWidget {
  final ExtraWrapper wrapper;
  const MyPage({
    Key? key,
    required this.wrapper,
  }) : super(key: key);
}

abstract class MyPageState<T extends MyPage> extends State<T> {
  late User? loggedInUser;
  late MyModel? myModel;
  late List<MyModel>? myList;
  late bool manageMode;
  String suffix = "";

  @override
  void initState() {
    super.initState();
    loggedInUser = widget.wrapper.user;
    myModel = widget.wrapper.model;
    if (myModel != null) {
      myList = myModel!.subList();
    }
    manageMode = false;
    if (myModel is Category) {
      suffix = "Types";
    } else if (myModel is ClothingType) {
      suffix = "Brands";
    } else if (myModel is Brand) {
      suffix = "Products";
    } else if (myModel is Product) {
      suffix = "Kinds";
    }
  }

  void onCreatePressed() {
    if (myModel is Category) {
      GoRouter.of(context).pushNamed(PageNames.mergeType,
          extra: ExtraWrapper(
              loggedInUser, ClothingType(category: myModel as Category)));
    } else if (myModel is ClothingType) {
      GoRouter.of(context).pushNamed(PageNames.mergeBrand,
          extra:
              ExtraWrapper(loggedInUser, Brand(type: myModel as ClothingType)));
    } else if (myModel is Brand) {
      GoRouter.of(context).pushNamed(PageNames.mergeProduct,
          extra:
              ExtraWrapper(loggedInUser, Product(brand: (myModel as Brand))));
    } else if (myModel is Product) {
      GoRouter.of(context).pushNamed(PageNames.mergeKind,
          extra: ExtraWrapper(loggedInUser, Kind(product: myModel as Product)));
    }
  }

  void onEditPressed(MyModel model) {
    final wrapper = ExtraWrapper(loggedInUser, model, editMode: true);
    if (model is Category) {
      GoRouter.of(context).pushNamed(PageNames.mergeCategory, extra: wrapper);
    } else if (model is ClothingType) {
      GoRouter.of(context).pushNamed(PageNames.mergeType, extra: wrapper);
    } else if (model is Brand) {
      GoRouter.of(context).pushNamed(PageNames.mergeBrand, extra: wrapper);
    } else if (model is Product) {
      GoRouter.of(context).pushNamed(PageNames.mergeProduct, extra: wrapper);
    } else if (model is Kind) {
      GoRouter.of(context).pushNamed(PageNames.mergeKind, extra: wrapper);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${myModel!.header()} $suffix'),
        elevation: 0,
        actions: prepareActions(context),
      ),
      body: myList != null
          ? manageMode
              ? displayList()
              : displayGrid()
          : const Center(child: Text('No Data Found!')),
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget displayGrid() {
    if (myModel is ClothingType) {
      if (loggedInUser == null || !loggedInUser!.isAdmin) {
        return MyGridView(
          myList: (myModel as ClothingType).typeProducts(),
          loggedInUser: loggedInUser,
        );
      }
    }
    return MyGridView(
      myList: myList,
      loggedInUser: loggedInUser,
    );
  }

  Widget displayList() {
    return myList!.isEmpty
        ? const Center(child: Text("Empty List"))
        : Container(
            padding: const EdgeInsets.all(4.0),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: myList!.length,
              itemBuilder: (BuildContext context, int index) {
                final model = myList!.elementAt(index);
                return Container(
                  color: Colors.amberAccent[index * 10],
                  child: ListTile(
                    title: Center(
                        child: Text(
                      model.header(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    leading: GestureDetector(
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed('upload_image', extra: model.id);
                      },
                      child: CachedNetworkImage(
                        imageUrl: Constants.getImageURL(model.id),
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
                        errorWidget: (context, url, error) => Image.asset(
                          Constants.noImageAssetPath,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                    onTap: () {
                      if (model is Product) {
                        GoRouter.of(context).pushNamed(PageNames.viewKinds,
                            extra: ExtraWrapper(loggedInUser, model));
                        return;
                      }

                      if (model is! Kind) {
                        GoRouter.of(context).pushNamed(PageNames.myGridPage,
                            extra: ExtraWrapper(loggedInUser, model));
                      }
                      /* if (widget.nextPage != null) {
                        context.pushNamed(widget.nextPage!, extra: model);
                      }
                      */
                    },
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: const Icon(Icons.edit),
                            onTap: () {
                              onEditPressed(model);
                              /*
                              if (widget.editPage != null) {
                                context.pushNamed(widget.editPage!,
                                    extra: model);
                              }
                              */
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
                                      DeleteDialog(wrapper: ExtraWrapper(loggedInUser, model)));
                              if (result == 0) {
                                setState(() {
                                  myList!.remove(model);
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
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ));
  }

  List<Widget> prepareActions(BuildContext context) {
    bool showManageIcon =
        (loggedInUser != null && loggedInUser!.role == Role.administrator);
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {},
      ),
      showManageIcon
          ? IconButton(
              icon: Icon(
                  !manageMode ? Icons.mode_edit_outline_sharp : Icons.close),
              onPressed: () {
                setState(() {
                  manageMode = !manageMode;
                });
              },
            )
          : IconButton(
              onPressed: () {
                GoRouter.of(context)
                    .pushNamed(PageNames.myShoppingCart, extra: loggedInUser);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
    ];
  }

  floatingActionButton() {
    return manageMode
        ? FloatingActionButton(
            onPressed: () async {
              onCreatePressed();
            },
            backgroundColor: Colors.amber,
            tooltip: 'Add',
            child: const Icon(Icons.add),
          )
        : Container();
  }
}
