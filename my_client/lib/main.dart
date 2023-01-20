import 'dart:ffi';

import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/brands/brand_list.dart';
import 'package:abdu_kids/pages/brands/brand_merge.dart';
import 'package:abdu_kids/pages/categories/category_list.dart';
import 'package:abdu_kids/pages/categories/category_merge.dart';
import 'package:abdu_kids/pages/kinds/kind_list.dart';
import 'package:abdu_kids/pages/kinds/kind_merge.dart';
import 'package:abdu_kids/pages/kinds/view_kinds.dart';
import 'package:abdu_kids/pages/products/product_list.dart';
import 'package:abdu_kids/pages/products/product_merge.dart';
import 'package:abdu_kids/pages/products/view_products.dart';
import 'package:abdu_kids/pages/types/type_list.dart';
import 'package:abdu_kids/pages/types/type_merge.dart';
import 'package:abdu_kids/pages/util/image_uloader.dart';
import 'package:abdu_kids/util/my_extra_wrapper.dart';
import 'package:abdu_kids/util/constants.dart';
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
        return const CategoryList();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'categories/types',
            name: 'types',
            builder: (context, state) {
              final extra = state.extra as MyExtraWrapper;
              return TypeList(
                  manageMode: extra.manageMode,
                  selectedCategory: extra.data as Category);
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'brands',
                  name: 'brands',
                  builder: (context, state) =>
                      BrandList(selectedType: state.extra as ClothingType),
                  routes: <RouteBase>[
                    GoRoute(
                        path: 'products',
                        name: 'products',
                        builder: (context, state) =>
                            ProductList(selectedBrand: state.extra as Brand),
                        routes: <RouteBase>[
                          GoRoute(
                              path: 'kinds',
                              name: 'kinds',
                              builder: (context, state) => KindList(
                                  selectedProduct: state.extra as Product),
                              routes: <RouteBase>[
                                GoRoute(
                                  path:
                                      'add_kind',
                                  name: 'add_kind',
                                  builder: (context, state) => KindMerge(
                                      editMode: false,
                                      selectedKind: state.extra as Kind),
                                ),
                                GoRoute(
                                  path:
                                      'edit_kind',
                                  name: 'edit_kind',
                                  builder: (context, state) => KindMerge(
                                      editMode: true,
                                      selectedKind: state.extra as Kind),
                                ),
                              ]),
                          GoRoute(
                            path: 'view_kinds',
                            name: 'view_kinds',
                            builder: (context, state) => ViewKinds(
                                selectedProduct: state.extra as Product),
                          ),
                          GoRoute(
                            path:
                                'add_product',
                            name: 'add_product',
                            builder: (context, state) => ProductMerge(
                                editMode: false,
                                selectedProduct: state.extra as Product),
                          ),
                          GoRoute(
                            path:
                                'edit_product',
                            name: 'edit_product',
                            builder: (context, state) => ProductMerge(
                                editMode: true,
                                selectedProduct: state.extra as Product),
                          )
                        ]),
                    GoRoute(
                      path: 'add_brand',
                      name: 'add_brand',
                      builder: (context, state) => BrandMerge(
                          editMode: false, selectedBrand: state.extra as Brand),
                    ),
                    GoRoute(
                      path: 'edit_brand',
                      name: 'edit_brand',
                      builder: (context, state) => BrandMerge(
                          editMode: true, selectedBrand: state.extra as Brand),
                    ),
                  ]),
              GoRoute(
                path: 'add_type',
                name: 'add_type',
                builder: (context, state) => TypeMerge(
                    editMode: false, selectedType: state.extra as ClothingType),
              ),
              GoRoute(
                path: 'edit_type',
                name: 'edit_type',
                builder: (context, state) => TypeMerge(
                    editMode: true, selectedType: state.extra as ClothingType),
              ),
              GoRoute(
                path: 'view_products',
                name: 'view_products',
                builder: (context, state) =>
                    ViewProducts(selectedType: state.extra as ClothingType),
              )
            ]),
        GoRoute(
            path: 'categories/merge_category/:${Constants.editMode}',
            name: 'merge_category',
            builder: (context, state) {
              Category category = state.extra as Category;
              return CategoryMerge(
                  editMode: state.params[Constants.editMode] == 'true',
                  selectedCategory: category);
            }),
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
