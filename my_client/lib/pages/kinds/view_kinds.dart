import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewKinds extends StatefulWidget {
  final Product selectedProduct;
  const ViewKinds({Key? key, required this.selectedProduct}) : super(key: key);

  @override
  State<ViewKinds> createState() => _ViewKinds();
}

class _ViewKinds extends State<ViewKinds> {
  late List<Kind> kindList;

  @override
  void initState() {
    super.initState();
    kindList = widget.selectedProduct.kinds;
    /*for (var i = 0; i < kindList.length; i++) {
      kindList[i].product = widget.selectedProduct;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.selectedProduct.brand!.name} Colors and Quantity"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: _displayKinds(kindList),
    );
  }

  Widget _displayKinds(List<Kind> kinds) {
    return kinds.isNotEmpty
        ? Container(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: kinds.length,
                itemBuilder: (BuildContext context, int index) {
                  final kind = kinds[index];
                  return SizedBox(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? (MediaQuery.of(context).size.height / 2)
                        : (MediaQuery.of(context).size.height / 1.5),
                    width: MediaQuery.of(context).size.width - 3,
                    child: Card(
                      child: Stack(
                        children: [
                          Ink.image(
                            image: NetworkImage(Constants.getImageURL(kind.id)),
                            fit: BoxFit.fill,
                            onImageError: (exception, stackTrace) => {
                              Image.asset(Constants.noImageAssetPath,
                                  fit: BoxFit.fill)
                            },
                            child: InkWell(
                              onTap: () {
                                //context.pushNamed('brands', extra: type);
                              },
                            ),
                          ),
                          Text(
                              "${kind.color}-${kind.product!.detail} /${kind.product!.size}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  backgroundColor: Colors.amber)),
                        ],
                      ),
                    ),
                  );
                }),
          )
        : Center(
            child: Text(
                'No Store Data about ${widget.selectedProduct.brand!.name} Product Kind is Found!'));
  }
}
