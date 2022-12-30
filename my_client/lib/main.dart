import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/pages/category_list.dart';
import 'package:abdu_kids/pages/category_merge.dart';
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
