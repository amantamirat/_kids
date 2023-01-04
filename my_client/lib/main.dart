import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/categories/category_list.dart';
import 'package:abdu_kids/pages/categories/category_merge.dart';
import 'package:abdu_kids/pages/products/product_list.dart';
import 'package:abdu_kids/pages/products/product_merge.dart';
import 'package:abdu_kids/pages/types/type_list.dart';
import 'package:abdu_kids/pages/types/type_merge.dart';
import 'package:abdu_kids/pages/util/image_uloader.dart';
import 'package:abdu_kids/util/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:abdu_kids/pages/util/my_preferences.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.
  await SharedPrefs.init();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHome();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'categories',
          builder: (BuildContext context, GoRouterState state) {
            return const CategoryList();
          },
          routes: <RouteBase>[
            GoRoute(
                path: 'categories/types',
                name: 'types',
                builder: (context, state) {
                  Category category = state.extra as Category;
                  return TypeList(selectedCategory: category);
                },
                routes: <RouteBase>[
                  GoRoute(
                      path: 'categories/types/products',
                      name: 'products',
                      builder: (context, state) => ProductList(
                          selectedType: state.extra as ClothingType),
                      routes: <RouteBase>[
                        GoRoute(
                          path: 'categories/types/products/add_product',
                          name: 'add_product',                          
                          builder: (context, state) => ProductMerge(
                              editMode: false,
                              selectedProduct: state.extra as Product),
                        ),
                        GoRoute(
                          path: 'categories/types/products/edit_product',
                          name: 'edit_product',                          
                          builder: (context, state) => ProductMerge(
                              editMode: true,
                              selectedProduct: state.extra as Product),
                        )
                      ]),
                  GoRoute(
                    path: 'categories/types/add_type',
                    name: 'add_type',
                    builder: (context, state) => TypeMerge(
                        editMode: false,
                        selectedType:
                            ClothingType(category: state.extra as Category)),
                  ),
                  GoRoute(
                    path: 'categories/types/edit_type',
                    name: 'edit_type',
                    builder: (context, state) => TypeMerge(
                        editMode: true,
                        selectedType: state.extra as ClothingType),
                  )
                ]),
            GoRoute(
              path: 'categories/add_category',
              name: 'add_category',
              builder: (context, state) =>
                  CategoryMerge(editMode: false, selectedCategory: Category()),
            ),
            GoRoute(
                path: 'categories/edit_category',
                name: 'edit_category',
                builder: (context, state) {
                  Category category = state.extra as Category;
                  return CategoryMerge(
                      editMode: true, selectedCategory: category);
                }),
          ],
        ),
        GoRoute(
          path: 'upload',
          name: 'upload_image',
          builder: (context, state) => ImageUploader(id: state.extra as String),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Abdu Kids',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      routerConfig: _router,
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

enum Menu { itemProduct, itemCategory, itemSettings }

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<Menu>(
              onSelected: (Menu item) {
                if (item == Menu.itemCategory) {
                  context.go('/categories');
                }
                if (item == Menu.itemSettings) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MySharedPreferences()));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    const PopupMenuItem<Menu>(
                      value: Menu.itemProduct,
                      child: Text('Products'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemCategory,
                      child: Text('Categories'),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.itemSettings,
                      child: Text('Settings'),
                    ),
                  ]),
        ],
      ),
      body: const Center(
        child: Text('Welcome Back!'),
      ),
    );
  }
}
