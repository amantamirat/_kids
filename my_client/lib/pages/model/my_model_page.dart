import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Menu { itemManage, itemSettings }

abstract class MyModelPage extends StatefulWidget {
  final List<MyModel> myList;
  final String? title;
  final String? editPage;
  final String? nextPage;
  final String? nextGridPage;

  MyModelPage(
      {Key? key,
      required this.myList,
      this.title,
      this.editPage,
      this.nextPage,
      this.nextGridPage})
      : super(key: key);
}

abstract class MyModelPageState<T extends MyModelPage> extends State<T> {
  late bool _manageMode = false;

  late List<MyModel> myList;

  @override
  void initState() {
    super.initState();
    myList = widget.myList;
  }

  void onCreatePressed();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
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
      body: _manageMode ? displayList() : displayGrid(),
      floatingActionButton: _manageMode
          ? FloatingActionButton(
              onPressed: () {
                onCreatePressed();
              },
              backgroundColor: Colors.green,
              tooltip: 'Add New',
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }

  Widget displayList() {
    return myList.isNotEmpty
        ? ListView.separated(
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
                    model.toString(),
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
          )
        : const Center(child: Text('No Data Found!'));
  }

  Widget displayGrid() {
    return Container(
      padding: const EdgeInsets.all(12.0),
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
                              context.pushNamed(widget.nextPage!, extra: model);
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
                              errorWidget: (context, url, error) => Image.asset(
                                    Constants.noImageAssetPath,
                                    width: 200,
                                    height: 200,
                                  )),
                        ),
                        Text(model.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.amber)),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
