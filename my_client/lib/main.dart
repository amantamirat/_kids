import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
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
import 'package:abdu_kids/pages/user/log_in.dart';
import 'package:abdu_kids/pages/user/user_list.dart';
import 'package:abdu_kids/pages/util/image_uloader.dart';
import 'package:abdu_kids/pages/util/shoping_cart.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/services/database_util.dart';
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
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'categories/types',
            name: PageName.types,
            builder: (context, state) {
              //final extra = state.extra as MyExtraWrapper;
              return TypeList(selectedCategory: state.extra as Category);
            },
            routes: <RouteBase>[
              GoRoute(
                  path: PageName.brands,
                  name: PageName.brands,
                  builder: (context, state) =>
                      BrandList(selectedType: state.extra as ClothingType),
                  routes: <RouteBase>[
                    GoRoute(
                        path: PageName.products,
                        name: PageName.products,
                        builder: (context, state) =>
                            ProductList(selectedModel: state.extra as MyModel),
                        routes: <RouteBase>[
                          GoRoute(
                              path: PageName.kinds,
                              name: PageName.kinds,
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
                                  path: PageName.addKind,
                                  name: PageName.addKind,
                                  builder: (context, state) => KindMerge(
                                      editMode: false,
                                      selectedKind: state.extra as Kind),
                                ),
                                GoRoute(
                                  path: PageName.editKind,
                                  name: PageName.editKind,
                                  builder: (context, state) => KindMerge(
                                      editMode: true,
                                      selectedKind: state.extra as Kind),
                                ),
                              ]),
                          GoRoute(
                            path: PageName.addProduct,
                            name: PageName.addProduct,
                            builder: (context, state) => ProductMerge(
                                editMode: false,
                                selectedProduct: state.extra as Product),
                          ),
                          GoRoute(
                            path: PageName.editProduct,
                            name: PageName.editProduct,
                            builder: (context, state) => ProductMerge(
                                editMode: true,
                                selectedProduct: state.extra as Product),
                          )
                        ]),
                    GoRoute(
                      path: PageName.addBrand,
                      name: PageName.addBrand,
                      builder: (context, state) => BrandMerge(
                          editMode: false, selectedBrand: state.extra as Brand),
                    ),
                    GoRoute(
                      path: PageName.editBrand,
                      name: PageName.editBrand,
                      builder: (context, state) => BrandMerge(
                          editMode: true, selectedBrand: state.extra as Brand),
                    ),
                  ]),
              GoRoute(
                path: PageName.addType,
                name: PageName.addType,
                builder: (context, state) => TypeMerge(
                    editMode: false, selectedType: state.extra as ClothingType),
              ),
              GoRoute(
                path: PageName.editType,
                name: PageName.editType,
                builder: (context, state) => TypeMerge(
                    editMode: true, selectedType: state.extra as ClothingType),
              ),
            ]),
        GoRoute(
          path: 'categories/merge_category',
          name: PageName.editCategory,
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
      path: '/${PageName.categories}',
      name: PageName.categories,
      builder: (context, state) =>
          CategoryList(categories: state.extra as List<Category>),
    ),
    GoRoute(
      path: '/${PageName.users}',
      name: PageName.users,
      builder: (context, state) => const UserList(),
    ),
    GoRoute(
      path: '/${PageName.login}',
      name: PageName.login,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/${PageName.myShoppingCart}',
      name: PageName.myShoppingCart,
      builder: (context, state) => const ShoppingCart(),
    ),
    GoRoute(
      path: '/upload',
      name: 'upload_image',
      builder: (context, state) => ImageUploader(id: state.extra as String),
    ),
    GoRoute(
      path: '/settings',
      name: PageName.settings,
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
                      ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.settings,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Configure'),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              GoRouter.of(context).pushNamed(PageName.settings);
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
