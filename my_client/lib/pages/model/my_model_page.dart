import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/pages/util/my_navigation_drawer.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

enum Menu { itemManage, itemSettings }

abstract class MyModelPage extends StatefulWidget {
  
  final List<MyModel> myList;
  final String? title;
  final String? editPage;
  final String? nextPage;
  final String? nextGridPage;
  final bool enableDrawer;
  final bool showCartIcon;
  final bool showManageIcon;
  final bool manageMode;

  const MyModelPage(
      {Key? key,
      required this.myList,
      this.title,
      this.editPage,
      this.nextPage,
      this.nextGridPage,
      this.enableDrawer = false,
      this.showCartIcon = true,
      this.showManageIcon = true,
      this.manageMode = false})
      : super(key: key);
}

abstract class MyModelPageState<T extends MyModelPage> extends State<T> {
  late bool _manageMode = widget.manageMode;
  late List<MyModel> myList;
  Future<dynamic>? myUser;
  User? loggedInUser;
  late bool isUserloggedin;

  @override
  void initState() {
    super.initState();
    myList = widget.myList;
    myUser = SessionManager().get(Constants.loggedInUser);
  }

  void onCreatePressed();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myUser,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            default:
              if (snapshot.hasError) {
                return Container();
              } else {
                if (snapshot.hasData) {
                  loggedInUser = User().fromJson(snapshot.data);
                }
                isUserloggedin = loggedInUser != null;

                return Scaffold(
                  appBar: AppBar(
                    title: Text("${widget.title}"),
                    elevation: 0,
                    actions: widget.showManageIcon &&
                            isUserloggedin &&
                            loggedInUser!.role == Role.administrator
                        ? <Widget>[
                            IconButton(
                              onPressed: () {
                                onCreatePressed();
                              },
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () => {_manageMode = !_manageMode},
                                );
                              },
                              icon: _manageMode
                                  ? const Icon(Icons.edit)
                                  : const Icon(Icons.view_agenda),
                            )
                          ]
                        : <Widget>[
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                            widget.showCartIcon
                                ? IconButton(
                                    onPressed: () {
                                      if (isUserloggedin) {
                                        GoRouter.of(context).pushNamed(
                                            PageNames.myShoppingCart,
                                            extra: loggedInUser);
                                        return;
                                      }

                                      GoRouter.of(context).pushNamed(
                                          PageNames.myShoppingCart,
                                          extra: null);
                                    },
                                    icon: const Icon(Icons.shopping_cart),
                                  )
                                : Container(),
                          ],
                  ),
                  drawer: widget.enableDrawer
                      ? isUserloggedin
                          ? MyNavigationDrawer(loggedInUser: loggedInUser!)
                          : MyNavigationDrawer()
                      : null,
                  body: myList.isNotEmpty
                      ? _manageMode
                          ? displayList()
                          : displayGrid()
                      : const Center(child: Text('No Data Found!')),
                );
              }
          }
        });
  }

  Widget displayList() {
    return Container(
        padding: const EdgeInsets.all(4.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          itemCount: myList.length,
          itemBuilder: (BuildContext context, int index) {
            final model = myList.elementAt(index);
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
                  if (widget.nextPage != null) {
                    context.pushNamed(widget.nextPage!, extra: model);
                  }
                },
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.edit),
                        onTap: () {
                          if (widget.editPage != null) {
                            context.pushNamed(widget.editPage!, extra: model);
                          }
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
                                  DeleteDialog(model: model));
                          if (result == 0) {
                            setState(() {
                              myList.remove(model);
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

  Widget displayGrid() {
    return Container(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
            itemCount: myList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 4,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final model = myList.elementAt(index);
              return Card(
                color: Colors.amber,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (widget.nextGridPage != null) {
                                context.pushNamed(widget.nextGridPage!,
                                    extra: model);
                              } else if (widget.nextPage != null) {
                                context.pushNamed(widget.nextPage!,
                                    extra: model);
                              }
                            },
                            child: CachedNetworkImage(
                                imageUrl: Constants.getImageURL(model.id),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      Constants.noImageAssetPath,
                                      width: 200,
                                      height: 200,
                                    )),
                          ),
                          Text(model.header(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.amber)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
