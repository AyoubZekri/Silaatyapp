import 'package:Silaaty/view/screen/Home.dart';
import 'package:Silaaty/view/screen/Prodact/Additem.dart';
import 'package:Silaaty/view/screen/profailedata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Homescreencontroller extends GetxController {
  // ignore: non_constant_identifier_names
  ChangePage(int currentpage);
}

class HomescreencontrollerImp extends Homescreencontroller {
  int currentpage = 0;

  List<Widget> Screen = [
    const Home(),
    const Additem(),
    const Profailedata(),
  ];

  List IconsScreen = [
    {'icon': Icons.home},
    {'icon': Icons.add_box_outlined},
    {'icon': Icons.person_2_sharp},
  ];

  @override
  ChangePage(int i) {
    currentpage = i;
    update();
  }
}
