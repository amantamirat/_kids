import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  Widget displayBrands(List<Brand> brands) {
    return brands.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: brands.length,
            itemBuilder: (BuildContext context, int index) {
              final brand = brands.elementAt(index);
              return Container(
                color: Colors.amberAccent[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${brand.name}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  leading: GestureDetector(
                    onTap: () {
                      context.pushNamed('upload_image', extra: brand.id);
                    },
                    child: CachedNetworkImage(
                      imageUrl: Constants.getImageURL(brand.id),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  onTap: () {
                    context.pushNamed('products', extra: brand);
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
                          onTap: () async {
                            int? result = await showDialog<int>(
                                context: context,
                                builder: (BuildContext context) =>
                                    DeleteDialog(model: brand));
                            if (result == 0) {
                              setState(() {
                                brandsList.remove(brand);
                              });
                            }
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
