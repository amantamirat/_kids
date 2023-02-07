import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class KindList extends MyModelPage {
  final Product selectedProduct;
  final Kind? selectedKind;

  KindList({Key? key, required this.selectedProduct, this.selectedKind})
      : super(
            key: key,
            myList: selectedProduct.kinds,
            title: "${selectedProduct.brand} Product Colors",
            editPage: PageNames.editKind,
            showCartIcon: selectedKind == null,
            showManageIcon: selectedKind == null);

  @override
  State<KindList> createState() => _KindList();
}

class _KindList extends MyModelPageState<KindList> {
  final CarouselController _controller = CarouselController();
  late List<Kind> _kindList = List.empty(growable: true);
  late List<Widget> imageSliders;
  int _activeIndex = 0;
  late double _quantity = 0;
  @override
  void initState() {
    super.initState();
    if (widget.selectedKind == null) {
      _kindList = widget.selectedProduct.kinds;
    } else {
      _kindList.add(widget.selectedKind!);
    }
    if (_kindList.isNotEmpty) {
      _computeMinMax();
    }
    imageSliders = _imageSliders();
  }

  @override
  void onCreatePressed() {
    context.pushNamed(PageNames.addKind,
        extra: Kind(product: widget.selectedProduct));
  }

  @override
  Widget displayGrid() {
    return SingleChildScrollView(child: _displayKinds());
  }

  Widget _displayKinds() {
    return _kindList.isNotEmpty
        ? Column(children: <Widget>[
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                height: widget.selectedKind != null
                    ? MediaQuery.of(context).size.height / 1.5
                    : MediaQuery.of(context).size.height / 2.5,
                onPageChanged: (index, reason) => setState(() {
                  _activeIndex = index;
                  _computeMinMax();
                }),
              ),
              carouselController: _controller,
            ),
            widget.selectedKind == null
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildIndicator(),
                      const SizedBox(height: 10),
                      _buildController()
                    ],
                  )
                : Container(),
            const SizedBox(height: 10),
            _buildTable(),
            widget.selectedKind == null
                ? Column(
                    children: [const SizedBox(height: 10), _buildCartForm()],
                  )
                : Container(),
          ])
        : Center(
            child: Text(
                'No Store Data about ${widget.selectedProduct.brand!.name} Product Kind is Found!'));
  }

  List<Widget> _imageSliders() {
    return _kindList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                          imageUrl: Constants.getImageURL(item.id),
                          fit: BoxFit.contain,
                          width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            '${item.color}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();
  }

  Widget _buildIndicator() {
    return AnimatedSmoothIndicator(
        activeIndex: _activeIndex,
        count: _kindList.length,
        onDotClicked: (index) => _controller.animateToPage(index),
        effect: const ScrollingDotsEffect(
          activeStrokeWidth: 2.6,
          activeDotScale: 1.3,
          maxVisibleDots: 5,
          radius: 8,
          spacing: 10,
          dotHeight: 16,
          dotWidth: 16,
        ));
  }

  Widget _buildController({bool strech = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
          onPressed: () => _controller.previousPage(
              duration: const Duration(microseconds: 500)),
          child: const Icon(
            Icons.arrow_back,
            size: 12,
          ),
        ),
        strech
            ? const Spacer()
            : const SizedBox(
                width: 32,
              ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
          onPressed: () =>
              _controller.nextPage(duration: const Duration(microseconds: 500)),
          child: const Icon(
            Icons.arrow_forward,
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    double width = MediaQuery.of(context).size.width;
    double textSize = width * 0.050;
    return Center(
        child: Table(
      border: TableBorder.all(),
      columnWidths: {
        0: const FlexColumnWidth(60),
        1: FlexColumnWidth(width / 3),
      },
      children: <TableRow>[
        TableRow(children: [
          Column(children: [
            Text('Product', style: TextStyle(fontSize: textSize))
          ]),
          Column(children: [
            Text(_kindList.elementAt(_activeIndex).header(),
                style: TextStyle(fontSize: textSize))
          ]),
        ]),
        TableRow(children: [
          Column(
              children: [Text('Color', style: TextStyle(fontSize: textSize))]),
          Column(children: [
            Text("${_kindList.elementAt(_activeIndex).color}",
                style: TextStyle(fontSize: textSize))
          ]),
        ]),
        TableRow(children: [
          Column(
              children: [Text('Price', style: TextStyle(fontSize: textSize))]),
          Column(children: [
            Text("${_kindList.elementAt(_activeIndex).product!.price} Birr",
                style: TextStyle(fontSize: textSize))
          ]),
        ]),
        TableRow(children: [
          Column(children: [
            Text('Quantity', style: TextStyle(fontSize: textSize))
          ]),
          Column(children: [
            Text("${_kindList.elementAt(_activeIndex).quantity}",
                style: TextStyle(fontSize: textSize))
          ]),
        ]),
      ],
    ));
  }

  double _min = 0;
  double _max = 0;

  void _computeMinMax() {
    _min = double.parse('${_kindList.elementAt(_activeIndex).product!.moq}');
    _max = double.parse('${_kindList.elementAt(_activeIndex).quantity}');
    _quantity = _min;
    if (_min > _max || _min == 0) {
      _min = 0;
      _max = 0;
    } else {
      _max = _max - (_max % _min);
    }
  }

  Widget _buildCartForm() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: SpinBox(
              onChanged: (value) {
                _quantity = value;
              },
              min: _min,
              step: _min,
              max: _max,
              value: _min,
              readOnly: true,
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12)),
                  onPressed: () async {
                    if (_quantity > 0) {
                      final kind = _kindList.elementAt(_activeIndex);
                      final item = CartItem(
                          kindId: kind.id!,
                          quantity: _quantity.toInt(),
                          price: kind.product!.price,
                          categoryId: kind.product!.brand!.type!.category!.id!,
                          typeId: kind.product!.brand!.type!.id!,
                          brandId: kind.product!.brand!.id!,
                          productId: kind.product!.id!);
                      if (widget.selectedKind == null) {
                        int result = await CartDataBase.insertItem(item);
                        if (result != 0) {
                          Fluttertoast.showToast(
                              msg: 'Item added to cart',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                        }
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add_shopping_cart,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Add to Cart'),
                    ],
                  ))),
        ],
      ),
    );
  }
}
