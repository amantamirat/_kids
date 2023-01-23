import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TypeList extends StatefulWidget {
  final bool manageMode;
  final Category selectedCategory;
  const TypeList(
      {Key? key, this.manageMode = false, required this.selectedCategory})
      : super(key: key);

  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  late List<ClothingType> _typeList;
  @override
  void initState() {
    super.initState();
    _typeList = widget.selectedCategory.clothingTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.selectedCategory.title} Clothing Types"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: widget.manageMode ? _displayList(_typeList) : _display(_typeList),
      floatingActionButton: widget.manageMode
          ? FloatingActionButton(
              onPressed: () {
                context.pushNamed('add_type',
                    extra: ClothingType(category: widget.selectedCategory));
              },
              backgroundColor: Colors.green,
              tooltip: 'Add Types',
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }

  Widget _displayList(List<ClothingType> types) {
    return Container(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: types.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final type = types.elementAt(index);
              return Container(
                color: Colors.amberAccent[index * 10],
                child: _myTypeListTile(type),
              );
            }));
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
                        InkWell(
                          onTap: () {
                            context.pushNamed('view_products', extra: type);
                          },
                          child: CachedNetworkImage(
                            imageUrl: Constants.getImageURL(type.id),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _myTypeListTile(ClothingType type) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          context.pushNamed('upload_image', extra: type.id);
        },
        child: CachedNetworkImage(
          imageUrl: Constants.getImageURL(type.id),
          imageBuilder: (context, imageProvider) => Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      title: Center(
          child: Text(
        "${type.type}",
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
              onTap: () async {
                int? result = await showDialog<int>(
                    context: context,
                    builder: (BuildContext context) =>
                        DeleteDialog(model: type));
                if (result == 0) {
                  setState(() {
                    _typeList.remove(type);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
