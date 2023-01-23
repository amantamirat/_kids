import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class KindList extends MyModelPage {
  
  final Product selectedProduct;

  KindList({Key? key, required this.selectedProduct})
      : super(
          key: key,
          myList: selectedProduct.kinds,
          title: "${selectedProduct.brand} Product Colors",
          editPage: PageName.editKind,
        );

  @override
  State<KindList> createState() => _KindList();
}

class _KindList extends MyModelPageState<KindList> {
  final CarouselController _controller = CarouselController();
  late List<Kind> kindList;
  late List<Widget> imageSliders;
  int activeIndex = 0;
  @override
  void initState() {
    super.initState();
    kindList = widget.selectedProduct.kinds;
    if (kindList.isNotEmpty) {
      _computeMinMax();
    }
    imageSliders = _imageSliders();
  }

  @override
  void onCreatePressed() {
    context.pushNamed(PageName.addKind,
        extra: Kind(product: widget.selectedProduct));
  }

  @override
  Widget displayGrid() {
    return SingleChildScrollView(child: _displayKinds(kindList));
  }

  Widget _displayKinds(List<Kind> kinds) {
    return kinds.isNotEmpty
        ? Column(children: <Widget>[
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                height: MediaQuery.of(context).size.height / 2,
                onPageChanged: (index, reason) => setState(() {
                  activeIndex = index;
                  _computeMinMax();
                }),
              ),
              carouselController: _controller,
            ),
            const SizedBox(height: 10),
            _buildIndicator(),
            const SizedBox(height: 10),
            _buildController(),
            const SizedBox(height: 10),
            _buildTable(),
            const SizedBox(height: 10),
            _buildCartForm(),
          ])
        : Center(
            child: Text(
                'No Store Data about ${widget.selectedProduct.brand!.name} Product Kind is Found!'));
  }

  List<Widget> _imageSliders() {
    return kindList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(Constants.getImageURL(item.id),
                          fit: BoxFit.contain, width: 1000.0),
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
        activeIndex: activeIndex,
        count: kindList.length,
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
    return Center(
        child: Table(
      border: TableBorder.all(),
      defaultColumnWidth: const FixedColumnWidth(120),
      children: <TableRow>[
        TableRow(children: [
          Column(children: const [
            Text('Color', style: TextStyle(fontSize: 20.0))
          ]),
          Column(children: [
            Text("${kindList.elementAt(activeIndex).color}",
                style: const TextStyle(fontSize: 20.0))
          ]),
        ]),
        TableRow(children: [
          Column(children: const [
            Text('Price', style: TextStyle(fontSize: 20.0))
          ]),
          Column(children: [
            Text("${kindList.elementAt(activeIndex).product!.price} Birr",
                style: const TextStyle(fontSize: 20.0))
          ]),
        ]),
        TableRow(children: [
          Column(children: const [
            Text('Quantity', style: TextStyle(fontSize: 20.0))
          ]),
          Column(children: [
            Text("${kindList.elementAt(activeIndex).quantity}",
                style: const TextStyle(fontSize: 20.0))
          ]),
        ]),
      ],
    ));
  }

  double _min = 0;
  double _max = 0;

  void _computeMinMax() {
    _min = double.parse('${kindList.elementAt(activeIndex).product!.moq}');
    _max = double.parse('${kindList.elementAt(activeIndex).quantity}');
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
                  onPressed: () => _controller.nextPage(
                      duration: const Duration(microseconds: 500)),
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
