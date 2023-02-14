import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  final List<MyModel>? myList;
  const MyGridView({super.key, this.myList});

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
            itemCount: myList!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 4,
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
                              /*
                              if (widget.nextGridPage != null) {
                                context.pushNamed(widget.nextGridPage!,
                                    extra: model);
                              } else if (widget.nextPage != null) {
                                context.pushNamed(widget.nextPage!,
                                    extra: model);
                              }
                              */
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
                                      width: 200,
                                      height: 200,
                                    )),
                          ),
                          Text(model.header(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.grey)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
  }
}
