// ignore_for_file: must_be_immutable

import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class MyNavigationDrawer extends StatefulWidget {
  final User? loggedInUser;
  const MyNavigationDrawer({super.key, this.loggedInUser});
  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawer();
}

class _MyNavigationDrawer extends State<MyNavigationDrawer> {
  late User? user;
  @override
  void initState() {
    super.initState();
    user = widget.loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildMenuItems(),
        ],
      ),
    ));
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.amber.shade100,
      padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        children: [
          user == null
              ? const CircleAvatar(
                  radius: 52,
                  backgroundImage:
                      ExactAssetImage("assets/images/CoffeeCup.jpg"),
                )
              : GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .pushNamed('upload_image', extra: user!.id);
                  },
                  child: CachedNetworkImage(
                      imageUrl: Constants.getImageURL(user!.id),
                      imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                            radius: 52,
                            backgroundImage:
                                ExactAssetImage(Constants.noImageAssetPath),
                          )),
                ),
          const SizedBox(
            height: 12,
          ),
          Text(
            user == null
                ? "Welcome!"
                : (user!.firstName == null
                    ? user!.role.title
                    : user!.firstName!),
            style: const TextStyle(fontSize: 28, color: Colors.black),
          ),
          Text(
            user == null ? "" : user!.email,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 12,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              context.pop();
              GoRouter.of(context).pushReplacementNamed(PageNames.home);
            },
          ),
          user == null
              ? Wrap(runSpacing: 12, children: [
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text("Log in"),
                    onTap: () {
                      context.pop();
                      context.pushNamed(PageNames.login);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.app_registration),
                    title: const Text("Register"),
                    onTap: () {
                      context.pop();
                      context.pushNamed(PageNames.register);
                    },
                  ),
                ])
              : Wrap(
                  runSpacing: 12,
                  children: [
                    user!.role == Role.administrator
                        ? Wrap(runSpacing: 12, children: [
                            ListTile(
                              leading: const Icon(Icons.account_circle_sharp),
                              title: const Text("User Accounts"),
                              onTap: () {
                                context.pop();
                                context.pushNamed(PageNames.users);
                              },
                            )
                          ])
                        : Wrap(runSpacing: 12, children: [
                            ListTile(
                              leading: const Icon(Icons.work_history),
                              title: const Text("My Orders"),
                              onTap: () {
                                context.pushNamed(PageNames.myOrderList,
                                    extra: user);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.badge),
                              title: const Text("Edit Profile"),
                              onTap: () {
                                context.pop();
                                context.pushNamed(PageNames.editProfile,
                                    extra: user);
                              },
                            ),
                          ]),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Log out"),
                      onTap: () async {
                        await SessionManager().remove(Constants.loggedInUser);
                        if (context.mounted) {
                          context.pop();
                          GoRouter.of(context)
                              .pushReplacementNamed(PageNames.home);
                        }
                      },
                    )
                  ],
                ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              GoRouter.of(context).pushNamed(PageNames.settings);
            },
          )
        ],
      ),
    );
  }
}
