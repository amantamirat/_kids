import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BrandList extends StatefulWidget {
  final ClothingType selectedType;
  const BrandList({Key? key, required this.selectedType}) : super(key: key);

  @override
  State<BrandList> createState() => _BrandList();
}

class _BrandList extends State<BrandList> {
  late List<Brand> brandsList;

  @override
  void initState() {
    super.initState();
    brandsList = widget.selectedType.brands;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.selectedType.category!.title} - ${widget.selectedType.type} Brands"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: displayBrands(brandsList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_brand',
              extra: Brand(type: widget.selectedType));
        },
        backgroundColor: Colors.green,
        tooltip: 'Apply Changes',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget displayBrands(brands) {
    return brands.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: brands.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.amberAccent[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${brands[index].name}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  leading: GestureDetector(
                    onTap: () {
                      context.pushNamed('upload_image',
                          extra: brands[index].id);
                    },
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            Constants.getImageURL(brands[index].id))),
                  ),
                  onTap: () {
                    context.pushNamed('products', extra: brands[index]);
                  },
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            context.pushNamed('edit_brand',
                                extra: brands[index]);
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
                                title: const Text('Delete Brand'),
                                content: const Text('Are you sure, proceed?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await MyService.deleteModel(
                                          brands[index])) {
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
        : Center(
            child: Text(
                'No Brands Data Found in ${widget.selectedType.category!.title} - ${widget.selectedType.type}!'));
  }
}
