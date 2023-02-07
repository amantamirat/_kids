import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/brands/brand_list.dart';
import 'package:abdu_kids/pages/brands/brand_merge.dart';
import 'package:abdu_kids/pages/categories/category_list.dart';
import 'package:abdu_kids/pages/categories/category_merge.dart';
import 'package:abdu_kids/pages/kinds/kind_list.dart';
import 'package:abdu_kids/pages/kinds/kind_merge.dart';
import 'package:abdu_kids/pages/products/product_list.dart';
import 'package:abdu_kids/pages/products/product_merge.dart';
import 'package:abdu_kids/pages/types/type_list.dart';
import 'package:abdu_kids/pages/types/type_merge.dart';
import 'package:abdu_kids/pages/user/change_password.dart';
import 'package:abdu_kids/pages/user/order_list.dart';
import 'package:abdu_kids/pages/user/verify_account.dart';
import 'package:abdu_kids/pages/user/edit_profile.dart';
import 'package:abdu_kids/pages/user/log_in.dart';
import 'package:abdu_kids/pages/user/register_user.dart';
import 'package:abdu_kids/pages/user/user_list.dart';
import 'package:abdu_kids/pages/util/image_uloader.dart';
import 'package:abdu_kids/pages/util/shoping_cart.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:abdu_kids/services/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:abdu_kids/pages/util/my_preferences.dart';
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
            path: 'categories/types',
            name: PageNames.types,
            builder: (context, state) {
              return TypeList(selectedCategory: state.extra as Category);
            },
            routes: <RouteBase>[
              GoRoute(
                  path: PageNames.brands,
                  name: PageNames.brands,
                  builder: (context, state) =>
                      BrandList(selectedType: state.extra as ClothingType),
                  routes: <RouteBase>[
                    GoRoute(
                        path: PageNames.products,
                        name: PageNames.products,
                        builder: (context, state) =>
                            ProductList(selectedModel: state.extra as MyModel),
                        routes: <RouteBase>[
                          GoRoute(
                              path: PageNames.kinds,
                              name: PageNames.kinds,
                              builder: (context, state) {
                                if (state.extra is Kind) {
                                  final kind = state.extra as Kind;
                                  return KindList(
                                    selectedProduct: kind.product!,
                                    selectedKind: kind,
                                  );
                                }
                                return KindList(
                                    selectedProduct: state.extra as Product);
                              },
                              routes: <RouteBase>[
                                GoRoute(
                                  path: PageNames.addKind,
                                  name: PageNames.addKind,
                                  builder: (context, state) => KindMerge(
                                      editMode: false,
                                      selectedKind: state.extra as Kind),
                                ),
                                GoRoute(
                                  path: PageNames.editKind,
                                  name: PageNames.editKind,
                                  builder: (context, state) => KindMerge(
                                      editMode: true,
                                      selectedKind: state.extra as Kind),
                                ),
                              ]),
                          GoRoute(
                            path: PageNames.addProduct,
                            name: PageNames.addProduct,
                            builder: (context, state) => ProductMerge(
                                editMode: false,
                                selectedProduct: state.extra as Product),
                          ),
                          GoRoute(
                            path: PageNames.editProduct,
                            name: PageNames.editProduct,
                            builder: (context, state) => ProductMerge(
                                editMode: true,
                                selectedProduct: state.extra as Product),
                          )
                        ]),
                    GoRoute(
                      path: PageNames.addBrand,
                      name: PageNames.addBrand,
                      builder: (context, state) => BrandMerge(
                          editMode: false, selectedBrand: state.extra as Brand),
                    ),
                    GoRoute(
                      path: PageNames.editBrand,
                      name: PageNames.editBrand,
                      builder: (context, state) => BrandMerge(
                          editMode: true, selectedBrand: state.extra as Brand),
                    ),
                  ]),
              GoRoute(
                path: PageNames.addType,
                name: PageNames.addType,
                builder: (context, state) => TypeMerge(
                    editMode: false, selectedType: state.extra as ClothingType),
              ),
              GoRoute(
                path: PageNames.editType,
                name: PageNames.editType,
                builder: (context, state) => TypeMerge(
                    editMode: true, selectedType: state.extra as ClothingType),
              ),
            ]),
        GoRoute(
          path: 'categories/merge_category',
          name: PageNames.editCategory,
          pageBuilder: (context, state) {
            return MaterialPage<int>(
              key: state.pageKey,
              child: CategoryMerge(
                  editMode: true, selectedCategory: state.extra as Category),
            );
          },
        ),
      ],
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
          EditProfile(selectedUser: state.extra as User),
    ),
    GoRoute(
      path: '/${PageNames.changePassword}',
      name: PageNames.changePassword,
      builder: (context, state) =>
          ChangePassword(selectedUser: state.extra as User),
    ),
    GoRoute(
      path: '/${PageNames.categories}',
      name: PageNames.categories,
      builder: (context, state) =>
          CategoryList(categories: MyService.myRootData!),
    ),
    GoRoute(
      path: '/${PageNames.users}',
      name: PageNames.users,
      builder: (context, state) {
        return FutureBuilder(
          future: UserService.getUsers(),
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
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${snapshot.error}'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return UserList(users: snapshot.data!);
                }
            }
          },
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
        return OrderList(selectedUser: state.extra as User);
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
  late Future<List<Category>?> _myFuture;
  @override
  void initState() {
    _myFuture = MyService.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              return Scaffold(
                appBar: AppBar(actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(PageNames.settings);
                    },
                    icon: const Icon(Icons.settings),
                  )
                ]),
                body: Center(
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
                              Text('Refresh'),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              _myFuture = MyService.getCategories();
                            });
                          }),
                    ],
                  ),
                ),
              );
            } else {
              return CategoryList(categories: snapshot.data!);
            }
        }
      },
    );
  }
}
