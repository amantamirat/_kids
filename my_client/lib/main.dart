import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/brands/merge_brand.dart';
import 'package:abdu_kids/pages/categories/merge_category.dart';
import 'package:abdu_kids/pages/kinds/merge_kind.dart';
import 'package:abdu_kids/pages/kinds/view_kinds.dart';
import 'package:abdu_kids/pages/my_dashboard.dart';
import 'package:abdu_kids/pages/my_grid_page.dart';
import 'package:abdu_kids/pages/products/merge_product.dart';
import 'package:abdu_kids/pages/types/merge_type.dart';
import 'package:abdu_kids/pages/user/change_password.dart';
import 'package:abdu_kids/pages/user/order_list.dart';
import 'package:abdu_kids/pages/user/verify_account.dart';
import 'package:abdu_kids/pages/user/edit_profile.dart';
import 'package:abdu_kids/pages/user/log_in.dart';
import 'package:abdu_kids/pages/user/register_user.dart';
import 'package:abdu_kids/pages/user/user_list.dart';
import 'package:abdu_kids/pages/util/image_uloader.dart';
import 'package:abdu_kids/pages/util/shoping_cart.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:abdu_kids/services/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:abdu_kids/pages/util/my_preferences.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await CartDataBase.init();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        name: PageNames.home,
        builder: (BuildContext context, GoRouterState state) {
          return const Home();
        },
        routes: <RouteBase>[
          GoRoute(
            path: PageNames.mergeCategory,
            name: PageNames.mergeCategory,
            builder: (context, state) {
              return MergeCategory(wrapper: state.extra as ExtraWrapper);
            },
          ),
          GoRoute(
            path: PageNames.mergeType,
            name: PageNames.mergeType,
            builder: (context, state) =>
                MergeType(wrapper: state.extra as ExtraWrapper),
          ),
          GoRoute(
            path: PageNames.mergeBrand,
            name: PageNames.mergeBrand,
            builder: (context, state) =>
                MergeBrand(wrapper: state.extra as ExtraWrapper),
          ),
          GoRoute(
            path: PageNames.mergeProduct,
            name: PageNames.mergeProduct,
            builder: (context, state) =>
                MergeProduct(wrapper: state.extra as ExtraWrapper),
          ),
          GoRoute(
            path: PageNames.mergeKind,
            name: PageNames.mergeKind,
            builder: (context, state) =>
                MergeKind(wrapper: state.extra as ExtraWrapper),
          ),
        ]),
    GoRoute(
      path: '/${PageNames.viewKinds}',
      name: PageNames.viewKinds,
      builder: (context, state) =>
          ViewKinds(wrapper: state.extra as ExtraWrapper),
    ),
    GoRoute(
      path: '/${PageNames.myGridPage}',
      name: PageNames.myGridPage,
      builder: (context, state) =>
          MyGridPage(wrapper: state.extra as ExtraWrapper),
    ),
    GoRoute(
      path: '/${PageNames.login}',
      name: PageNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/${PageNames.register}',
      name: PageNames.register,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/${PageNames.verify}',
      name: PageNames.verify,
      builder: (context, state) =>
          VerifyAccount(selectedUser: state.extra as User),
    ),
    GoRoute(
      path: '/${PageNames.editProfile}',
      name: PageNames.editProfile,
      builder: (context, state) =>
          EditProfile(wrapper: state.extra as ExtraWrapper),
    ),
    GoRoute(
      path: '/${PageNames.changePassword}',
      name: PageNames.changePassword,
      builder: (context, state) =>
          ChangePassword(selectedUser: state.extra as User),
    ),
    GoRoute(
      path: '/${PageNames.users}',
      name: PageNames.users,
      builder: (context, state) {
        return UserList(
          loggedInUser: state.extra as User,
        );
      },
    ),
    GoRoute(
      path: '/${PageNames.myShoppingCart}',
      name: PageNames.myShoppingCart,
      builder: (context, state) {
        if (state.extra == null) {
          return const ShoppingCart(loggedInUser: null);
        }
        return ShoppingCart(loggedInUser: state.extra as User);
      },
    ),
    GoRoute(
      path: '/${PageNames.myOrderList}',
      name: PageNames.myOrderList,
      builder: (context, state) {
        return MyOrderList(loggedInUser: state.extra as User);
      },
    ),
    GoRoute(
      path: '/upload',
      name: 'upload_image',
      builder: (context, state) => ImageUploader(id: state.extra as String),
    ),
    GoRoute(
      path: '/settings',
      name: PageNames.settings,
      builder: (context, state) => const MySharedPreferences(),
    ),
  ],
  //error page goes here....
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      routerConfig: _router,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late Future<dynamic>? _myUser;
  @override
  void initState() {
    super.initState();
    _myUser = SessionManager().get(Constants.loggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _myUser,
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
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
                return MyDashboard(
                    loggedInUser: snapshot.hasData
                        ? User().fromJson(snapshot.data)
                        : null);
              }
          }
        },
      ),
    );
  }
}
