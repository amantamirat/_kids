import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
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
    /*for (var i = 0; i < typeList.length; i++) {
      typeList[i].category = widget.selectedCategory;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.selectedCategory.title} Clothing Types"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: _display(typeList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_type',
              extra: ClothingType(category: widget.selectedCategory));
        },
        backgroundColor: Colors.green,
        tooltip: 'Add Types',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _display(List<ClothingType> types) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
          itemCount: types.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 4,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final type = types.elementAt(index);
            return Card(
              color: Colors.amber,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Ink.image(
                          image: NetworkImage(Constants.getImageURL(type.id)),
                          fit: BoxFit.fill,
                          onImageError: (exception, stackTrace) => {
                            Image.asset(Constants.noImageAssetPath,
                                fit: BoxFit.fill)
                          },
                          child: InkWell(
                            onTap: () {
                              context.pushNamed('view_products', extra: type);
                            },
                          ),
                        ),
                        Text("${type.type}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.amber)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(2).copyWith(bottom: 0),
                      child: _myFooter(type))
                ],
              ),
            );
          }),
    );
  }

  Widget _myFooter(ClothingType type) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          context.pushNamed('upload_image', extra: type.id);
        },
        child: CircleAvatar(
            backgroundImage: NetworkImage(Constants.getImageURL(type.id))),
      ),
      title: Center(
          child: Text(
        "${type.brands.length}",
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
      )),
      onTap: () {
        context.pushNamed('brands', extra: type);
      },
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width / 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              child: const Icon(Icons.edit),
              onTap: () {
                context.pushNamed('edit_type', extra: type);
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
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (await MyService.deleteModel(type)) {
                            Fluttertoast.showToast(
                                msg: 'Removed!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.yellow);
                            typeList.remove(type);
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
    );
  }
}
