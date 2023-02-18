import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/user/order_list.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:abdu_kids/util/constants.dart';

class UserList extends StatefulWidget {
  final User? loggedInUser;
  const UserList({Key? key, this.loggedInUser}) : super(key: key);
  @override
  State<UserList> createState() => _UserList();
}

class _UserList extends State<UserList> {
  late Future<List<User>?> _myFuture;
  @override
  void initState() {
    super.initState();
    _myFuture = UserService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users List")),
      body: FutureBuilder(
        future: _myFuture,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<User>?> snapshot,
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
                    ? const Center(child: Text("No Users Found!"))
                    : _displayUserList(snapshot.data!);
              }
          }
        },
      ),
    );
  }

  Widget _displayUserList(List<User> userList) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(8),
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index) {
            final user = userList.elementAt(index);
            return Container(
              color: Colors.amberAccent[index * 10],
              child: ListTile(
                title: Center(
                    child: Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                leading: GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .pushNamed('upload_image', extra: user.id);
                  },
                  child: CachedNetworkImage(
                    imageUrl: Constants.getImageURL(user.id),
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
                  //context.pushNamed(PageNames.myOrderList, extra: user);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text("User Orders"),
                                ),
                                body: OrderList(orders: user.orders),
                              )));
                },
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.edit),
                        onTap: () {
                          context.pushNamed(PageNames.editProfile,
                              extra: ExtraWrapper(widget.loggedInUser, user));
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
                              builder: (BuildContext context) => DeleteDialog(
                                    wrapper:
                                        ExtraWrapper(widget.loggedInUser, user),
                                  ));
                          if (result == 0) {
                            setState(() {
                              userList.remove(user);
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
}
