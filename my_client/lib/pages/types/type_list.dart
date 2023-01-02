import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/services/category_Service.dart';
import 'package:abdu_kids/util/configuration.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TypeList extends StatefulWidget {
  final Category selectedCategory;
  const TypeList({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  late List<ClothingType> typeList;

  @override
  void initState() {
    super.initState();
    typeList = widget.selectedCategory.clothingTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.selectedCategory.title} Clothing Types"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: displayTypes(typeList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('add_category');
        },
        backgroundColor: Colors.green,
        tooltip: 'Add Types',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget displayTypes(types) {
    return types.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: types.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.amber[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${types[index].type}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  leading: GestureDetector(
                    onTap: () {
                      context.goNamed('upload_image', extra: types[index].id);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Image.network(
                        Configuration.getImageURL(types[index].id),
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              "assets/images/No-Image-Placeholder.svg.png");
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
                            /*context.goNamed('edit_category',
                                extra: products[index]);*/
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
                                title: const Text('Delete Type'),
                                content: const Text('Are you sure, proceed?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await CategoryService.deleteCategory(
                                          types[index].id)) {
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
        : const Center(child: Text('No Types Found!'));
  }
}
