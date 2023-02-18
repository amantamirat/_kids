import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGridView extends StatelessWidget {
  final List<MyModel>? myList;
  final User? loggedInUser;
  final bool isSubGrid;

  const MyGridView(
      {super.key, this.myList, this.loggedInUser, this.isSubGrid = false});

  @override
  Widget build(BuildContext context) {
    return myList!.isEmpty
        ? const Center(child: Text("Empty List"))
        : GridView.builder(
            itemCount: myList!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: !isSubGrid
                  ? MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 4
                  : 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final model = myList!.elementAt(index);
              return Card(
                color: Colors.amber,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (model is Product) {
                                GoRouter.of(context).pushNamed(
                                    PageNames.viewKinds,
                                    extra: ExtraWrapper(loggedInUser, model));
                                return;
                              }

                              if (model is! Kind) {
                                GoRouter.of(context).pushNamed(
                                    PageNames.myGridPage,
                                    extra: ExtraWrapper(loggedInUser, model));
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
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      Constants.noImageAssetPath,
                                      width: !isSubGrid ? 200 : 80,
                                      height: !isSubGrid ? 200 : 80,
                                    )),
                          ),
                          Text(model.header(),
                              style: TextStyle(
                                  fontSize: !isSubGrid ? 16 : 12,
                                  color:
                                      !isSubGrid ? Colors.black : Colors.white,
                                  fontWeight: !isSubGrid
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  backgroundColor:
                                      !isSubGrid ? Colors.amber : Colors.grey)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
  }
}
