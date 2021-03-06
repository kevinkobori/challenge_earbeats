import "package:flutter/material.dart";
import "dart:ui";
import "package:flutter_card_swipper/flutter_card_swiper.dart";
import "package:kevinkobori_challenge_earbeats/widgets/product_card.dart";
import "package:kevinkobori_challenge_earbeats/models/product_model.dart";
import "package:kevinkobori_challenge_earbeats/providers/product_provider.dart";
import 'package:delayed_display/delayed_display.dart';
import "package:kevinkobori_challenge_earbeats/views/details_page.dart";
import 'package:kevinkobori_challenge_earbeats/widgets/quantity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SwiperController _swiperController = SwiperController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ProductModel> productsList = ProductsState().categoryEarphones;
  int indexPage = 0;
  int indexType = 0;
  bool isEnabled = true;
  bool isHover = false;

  @override
  void initState() {
    _swiperController.move(0);
    super.initState();
    _swiperController.addListener(() {
      // setState(() {
        indexType = _swiperController.index;
      // });
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  waitToPressAgain() {
    // setState(() {
    //   isEnabled = false;
    // });
    Future.delayed(Duration(milliseconds: 1201)).then((value) {
      // setState(() {
      //   isEnabled = true;
      // });
    });
  }

  onTapPrevious() {
    waitToPressAgain();
    _swiperController.previous();
    _swiperController.index = _swiperController.index.abs();
    _swiperController.index--;
    _swiperController.index = _swiperController.index % (productsList.length);
  }

  onTapNext() {
    waitToPressAgain();
    _swiperController.next();
    _swiperController.index = _swiperController.index.abs();
    _swiperController.index++;
    _swiperController.index = _swiperController.index % (productsList.length);
  }

  getDisplayDeplayed(BoxConstraints constraints) {
    return DelayedDisplay(
      delay: Duration(milliseconds: 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        margin: EdgeInsets.fromLTRB(
            32, 32, constraints.maxWidth > 1200 ? 96 : 32, 64),
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        width: 400,
        height: 369,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productsList[_swiperController.index].name,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              productsList[_swiperController.index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 52,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              productsList[_swiperController.index].desc,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 64,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        DetailsPage(
                      product: productsList[_swiperController.index],
                    ),
                    transitionDuration: Duration(seconds: 2),
                  ),
                );
              },
              onHover: (value) {
                setState(() {
                  isHover = value;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          'EXPLORE PRODUCT',
                          style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Arimo',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.call_made),
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: isHover ? 192 : 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isHover ? Colors.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double _swiperWidth = MediaQuery.of(context).size.width;
        // final double space = (_swiperWidth! - widget.itemWidth!) / 2;
        double itemWidth = constraints.maxWidth > 900
            ? MediaQuery.of(context).size.height / 1.2
            : MediaQuery.of(context).size.width / 1.2;
        double space = (_swiperWidth - itemWidth) / 2;
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: Container(
              color: Colors.grey[300],
              height: MediaQuery.of(context).size.height,
            ),
          ),
          extendBody: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg_2.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: constraints.maxWidth > 750 ? 6 : 1),
                  Container(
                    color: Colors.transparent,
                    child: Swiper(
                      onIndexChanged: (index) {
                        // setState(() {
                          indexType = index;
                        // });
                        // _swiperController.index = index;
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      layout: SwiperLayout.CUSTOM,
                      customLayoutOption:
                          CustomLayoutOption(startIndex: -1, stateCount: 5)
                              .addTranslate([
                        Offset(-space - 100, 0.0),
                        Offset((-space / 3 * 2) - 140, 0.0),
                        Offset((-space / 3) - 200, 0.0),
                        Offset(0.0, 0.0),
                        Offset(_swiperWidth, 0.0),
                      ]).addScale(
                        [0.1, 0.2, 0.6, 1, 2.0],
                        Alignment.centerRight,
                      ).addOpacity(
                        [0, 0.6, 0.8, 1.0, 0.0],
                      ),
                      itemHeight: constraints.maxWidth > 900
                          ? MediaQuery.of(context).size.height / 1.2
                          : MediaQuery.of(context).size.width / 1.2,
                      itemWidth: constraints.maxWidth > 900
                          ? MediaQuery.of(context).size.height / 1.2
                          : MediaQuery.of(context).size.width / 1.2,
                      scrollDirection: Axis.horizontal,
                      controller: _swiperController,
                      itemCount: productsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            ProductCard(
                              productsList: productsList,
                              index: index,
                              onTapPrevious: () => onTapPrevious(),
                              onTapNext: () => onTapNext(),
                              currentIndex: _swiperController.index,
                              width: 230,
                              isEnabled: isEnabled,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Spacer(
                    flex: 6,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    constraints.maxWidth > 810 ? 128 : 32,
                    constraints.maxWidth > 810 ? 0 : 32,
                    constraints.maxWidth > 810 ? 128 : 32,
                    0),
                child: constraints.maxWidth > 810
                    ? Row(
                        children: [
                          Container(
                            height: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.bar_chart_rounded, size: 36),
                                    SizedBox(width: 16),
                                    Text(
                                      'earbeats',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 10),
                          Container(
                            height: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: 40,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'EarBuds',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 1),
                          Container(
                            height: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: 40,
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Headphones',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 1),
                          Container(
                            height: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: 40,
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Accessories',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 1),
                          Container(
                            height: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: 40,
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Software',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 1),
                          Container(
                            height: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  height: 40,
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Support',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    fontFamily: 'Arimo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(Icons.bar_chart_rounded, size: 36),
                          SizedBox(width: 16),
                          Text(
                            'earbeats',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.menu),
                        ],
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      constraints.maxWidth > 750 ? 128 : 32,
                      0,
                      constraints.maxWidth > 750 ? 128 : 32,
                      constraints.maxWidth > 750 ? 64 : 32),
                  child: Quantity(
                    swiperControllerIndex: indexType, //_swiperController.index,
                    productsListLength: productsList.length,
                  ),
                ),
              ),
              Align(
                alignment: constraints.maxWidth > 1400
                    ? Alignment.centerRight
                    : Alignment.bottomRight,
                child:
                    isEnabled ? getDisplayDeplayed(constraints) : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
