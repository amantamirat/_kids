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
import 'package:abdu_kids/pages/util/image_uloader.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/page_names.dart';
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
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return FutureBuilder(
          future: MyService.getCategories(),
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
                  return Center(
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
                                Text('Try Again'),
                              ],
                            ),
                            onPressed: () {}),
                      ],
                    ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return CategoryList(categories: snapshot.data!);
                  }
                  return const Center(child: Text('No Data is Found!'));
                }
            }
          },
        );
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
                              builder: (context, state) => KindList(
                                  selectedProduct: state.extra as Product),
                              routes: <RouteBase>[
                                GoRoute(
                                  path: 'add_kind',
                                  name: 'add_kind',
                                  builder: (context, state) => KindMerge(
                                      editMode: false,
                                      selectedKind: state.extra as Kind),
                                ),
                                GoRoute(
                                  path: 'edit_kind',
                                  name: 'edit_kind',
                                  builder: (context, state) => KindMerge(
                                      editMode: true,
                                      selectedKind: state.extra as Kind),
                                ),
                              ]),
                          /*
                          GoRoute(
                            path: 'view_kinds',
                            name: 'view_kinds',
                            builder: (context, state) => ViewKinds(
                                selectedProduct: state.extra as Product),
                          ),
                          */
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
              /*
              GoRoute(
                path: PageName.viewProducts,
                name: PageName.viewProducts,
                builder: (context, state) =>
                    ViewProducts(selectedType: state.extra as ClothingType),
              )
              */
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
          /*
            builder: (context, state) {
              final extra = state.extra as MyExtraWrapper;
              return CategoryMerge(
                  editMode: extra.editMode,
                  selectedCategory: extra.data as Category);
            }
            */
        ),
      ],
    ),
    GoRoute(
      path: '/upload',
      name: 'upload_image',
      builder: (context, state) => ImageUploader(id: state.extra as String),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
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
