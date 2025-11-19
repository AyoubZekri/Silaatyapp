import 'package:Silaaty/view/screen/Home.dart';
import 'package:Silaaty/view/screen/Setteng.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/screen/Statistics.dart';

abstract class Homescreencontroller extends GetxController {
  // ignore: non_constant_identifier_names
  ChangePage(int currentpage);
}

class HomescreencontrollerImp extends Homescreencontroller {
  int currentpage = 0;

  List<Widget> Screen = [
    const Home(),
    const Statistics(),
    const Setteng(),
  ];

  List IconsScreen = [
    {'icon': Icons.home},
    {'icon': Icons.bar_chart_sharp},
    {'icon': Icons.settings},
  ];

  @override
  ChangePage(int i) {
    currentpage = i;
    update();
  }
}
