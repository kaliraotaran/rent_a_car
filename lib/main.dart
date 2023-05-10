import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rent_a_car/bloc/state_bloc.dart';
import 'package:rent_a_car/bloc/state_provider.dart';
import 'package:rent_a_car/model/car.dart';

void main() {
  runApp(MainApp());
}

var currentCar = carList.cars[0];

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsets.only(left: 25),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 25),
              child: const Icon(Icons.favorite_border),
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: LayoutStarts(),
      ),
    );
  }
}

class LayoutStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarDetailsAnimation(),
        CustomButtomSheet(),
        RentButton(),
      ],
    );
  }
}

class RentButton extends StatelessWidget {
  const RentButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(25),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(35)))),
            child: const Text(
              "Rent Car",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 1.4,
                  fontFamily: "arial"),
            )),
      ),
    );
  }
}

class CarDetailsAnimation extends StatefulWidget {
  // const CarDetailsAnimation({super.key});

  @override
  State<CarDetailsAnimation> createState() => _CarDetailsAnimationState();
}

class _CarDetailsAnimationState extends State<CarDetailsAnimation>
    with TickerProviderStateMixin {
  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  @override
  void initState() {
    super.initState();
    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);

    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
        parent: scaleController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut));
  }

  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: StateProvider().isAnimating,
        stream: stateBloc.animationStatus,
        builder: (context, snapshot) {
// this could be the problem bottom
          snapshot.data ? forward() : reverse();
          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: CarDetails(),
            ),
          );
        });
  }
}

class CarDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          child: _carTitle(),
        ),
        Container(
          width: double.infinity,
          child: _CarCarousel(),
        )
      ]),
    );
  }

  _carTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
            text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 38),
                children: [
              TextSpan(text: currentCar.companyName),
              const TextSpan(text: "\n"),
              TextSpan(
                  text: currentCar.carName,
                  style: const TextStyle(fontWeight: FontWeight.w700))
            ])),
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: TextSpan(style: const TextStyle(fontSize: 16), children: [
          TextSpan(
            text: currentCar.price.toString(),
            style: TextStyle(color: Colors.grey[20]),
          ),
          const TextSpan(text: " / day", style: TextStyle(color: Colors.grey))
        ]))
      ],
    );
  }
}

class _CarCarousel extends StatefulWidget {
  //const _CarCarousel({super.key});

  @override
  State<_CarCarousel> createState() => __CarCarouselState();
}

class __CarCarouselState extends State<_CarCarousel> {
  static final List<String> imgList = currentCar.imgList;

  final List<Widget> child = _map<Widget>(imgList, (index, String assetName) {
    return Container(
        child: Image.asset("assets/$assetName", fit: BoxFit.fitWidth));
  }).toList();

  static List<T> _map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: child,
            // height: 250,
            // viewportFraction: 1.0,
            options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                onPageChanged: (index, _) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _map<Widget>(imgList, (index, assetName) {
                  return Container(
                    width: 50,
                    height: 2,
                    decoration: BoxDecoration(
                        color: _current == index
                            ? Colors.grey[100]
                            : Colors.grey[600]),
                  );
                })),
          )
        ],
      ),
    );
  }
}

class CustomButtomSheet extends StatefulWidget {
  //const CustomButtomSheet({super.key});

  @override
  State<CustomButtomSheet> createState() => _CustomButtomSheetState();
}

// this could be the potential problem for the scroll up issue
class _CustomButtomSheetState extends State<CustomButtomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop = 400;
  double minSheetTop = 30;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: sheetTop, end: minSheetTop).animate(
        CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
            reverseCurve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
  }

  forwardAnimation() {
    controller.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    controller.reverse();
    stateBloc.toggleAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          // this is the upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            // this is the downlard drag
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  // const SheetContainer({super.key});

  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        color: Color(0xfff1f1f1),
      ),
      child: Column(children: <Widget>[
        drawerHandle(),
        Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                offerDetails(sheetItemHeight),
                specifications(sheetItemHeight),
                features(sheetItemHeight),
                SizedBox(
                  height: 220,
                )
              ],
            ))
      ]),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffd9dbdb)),
    );
  }

  specifications(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Specifications',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCar.specifications.length,
              itemBuilder: (context, index) {
                return ListItem(
                    sheetItemHeight: sheetItemHeight,
                    mapVal: currentCar.specifications[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  features(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Features',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCar.features.length,
              itemBuilder: (context, index) {
                return ListItem(
                    sheetItemHeight: sheetItemHeight,
                    mapVal: currentCar.features[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  offerDetails(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Offer Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentCar.offerDetails.length,
              itemBuilder: (context, index) {
                return ListItem(
                    sheetItemHeight: sheetItemHeight,
                    mapVal: currentCar.offerDetails[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final Map mapVal;
  ListItem({@required this.mapVal, @required this.sheetItemHeight});

  @override
  Widget build(BuildContext context) {
    var innerMap;
    bool isMap;

    if (mapVal.values.elementAt(0) is Map) {
      innerMap = mapVal.values.elementAt(0);
      isMap = true;
    } else {
      innerMap = mapVal;
      isMap = false;
    }

    return Container(
      margin: EdgeInsets.only(right: 20),
      width: sheetItemHeight,
      height: sheetItemHeight,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          mapVal.keys.elementAt(0),
          isMap
              ? Text(
                  innerMap.keys.elementAt(0),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.2,
                    fontSize: 11,
                  ),
                )
              : Container(),
          Text(
            innerMap.values.elementAt(0),
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
          )
        ],
      ),
    );
  }
}
