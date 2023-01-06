import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class KindList extends StatefulWidget {
  final Product selectedProduct;
  const KindList({Key? key, required this.selectedProduct}) : super(key: key);

  @override
  State<KindList> createState() => _KindList();
}

class _KindList extends State<KindList> {
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
        title: Text("${widget.selectedProduct.brand!.name} Colors and Quantity"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: displayKinds(kindList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_kind', extra: Kind(product: widget.selectedProduct));
        },
        backgroundColor: Colors.green,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget displayKinds(kinds) {
    return kinds.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: kinds.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.amber[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${kinds[index].color}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  subtitle: Text("Quantity ${kinds[index].quantity}"),
                  leading: GestureDetector(
                    onTap: () {
                      context.pushNamed('upload_image', extra: kinds[index].id);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Image.network(
                        Constants.getImageURL(kinds[index].id),
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(Constants.noImageAssetPath);
                        },
                      ),
                    ),
                  ),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            context.pushNamed('edit_kind', extra: kinds[index]);
                          },
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Store'),
                                content: const Text('Are you sure, you better edit it?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await MyService.deleteModel(
                                          kinds[index])) {
                                        Fluttertoast.showToast(
                                            msg: 'Removed!',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.yellow);
                                        setState(() {});
                                        context.pop();
                                      }
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )
        :  Center(child: Text('No Store Data about ${widget.selectedProduct.brand!.name} Product Found!'));
  }
}