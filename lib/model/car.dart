import 'package:flutter/material.dart';

double iconSize = 30;

CarList carList = CarList(cars: [
  Car(companyName: "Mercedes", carName: "G-Wagon", price: 6500, imgList: [
    "GEx.png",
    "GIn.png",
    "GIn1.png",
  ], offerDetails: [
    {Icon(Icons.bluetooth, size: iconSize): "Automatic"},
    {Icon(Icons.airline_seat_individual_suite, size: iconSize): "4 seats"},
    {Icon(Icons.pin_drop, size: iconSize): "6.4L"},
    {Icon(Icons.shutter_speed, size: iconSize): "5HP"},
    {Icon(Icons.invert_colors, size: iconSize): "Variant Colours"},
  ], specifications: [
    {
      Icon(Icons.av_timer, size: iconSize): {"Milegp(upto)": "14.2 kmpl"}
    },
    {
      Icon(Icons.power, size: iconSize): {"Engine(upto)": "3996 cc"}
    },
    {
      Icon(Icons.assignment_late, size: iconSize): {"BHP": "700"}
    },
    {
      Icon(Icons.account_balance_wallet, size: iconSize): {
        "More Specs": "14.2 kmpl"
      }
    },
    {
      Icon(Icons.cached, size: iconSize): {"More Specs": "14.2 kmpl"}
    },
  ], features: [
    {Icon(Icons.bluetooth, size: iconSize): "Bluetooth"},
    {Icon(Icons.usb, size: iconSize): "USB Port"},
    {Icon(Icons.power_settings_new, size: iconSize): "Keyless"},
    {Icon(Icons.android, size: iconSize): "Android Auto"},
    {Icon(Icons.ac_unit, size: iconSize): "AC"},
  ]),
  Car(companyName: "Land Rover", carName: "Range Rover", price: 3000, imgList: [
    "RREx1.png",
    "RREx2.png",
    "RRIn.png",
    "RRIn1.png",
  ], offerDetails: [
    {Icon(Icons.bluetooth, size: iconSize): "Automatic"},
    {Icon(Icons.bluetooth, size: iconSize): "4 seats"},
    {Icon(Icons.bluetooth, size: iconSize): "6.4L"},
    {Icon(Icons.bluetooth, size: iconSize): "5HP"},
    {Icon(Icons.bluetooth, size: iconSize): "Variant Colours"},
  ], specifications: [
    {
      Icon(Icons.bluetooth, size: iconSize): {"Milegp(upto)": "14.2 kmpl"}
    },
    {
      Icon(Icons.bluetooth, size: iconSize): {"Engine(upto)": "3996 cc"}
    },
    {
      Icon(Icons.bluetooth, size: iconSize): {"BHP": "700"}
    },
    {
      Icon(Icons.bluetooth, size: iconSize): {"Milegp(upto)": "14.2 kmpl"}
    },
    {
      Icon(Icons.bluetooth, size: iconSize): {"Milegp(upto)": "14.2 kmpl"}
    },
  ], features: [
    {Icon(Icons.bluetooth, size: iconSize): "Bluetooth"},
    {Icon(Icons.bluetooth, size: iconSize): "USB Port"},
    {Icon(Icons.bluetooth, size: iconSize): "Keyless"},
    {Icon(Icons.bluetooth, size: iconSize): "Android Auto"},
    {Icon(Icons.bluetooth, size: iconSize): "AC"},
  ])
]);

class CarList {
  List<Car> cars;
  CarList({@required this.cars});
}

class Car {
  String companyName;
  String carName;
  int price;
  List<String> imgList;

  List<Map<Icon, String>> offerDetails;

  List<Map<Icon, String>> features;

  List<Map<Icon, Map<String, String>>> specifications;

  Car({
    @required this.carName,
    @required this.companyName,
    @required this.features,
    @required this.imgList,
    @required this.offerDetails,
    @required this.price,
    @required this.specifications,
  });
}
