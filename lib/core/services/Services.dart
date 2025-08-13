import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  Myservices extends GetxService{
   SharedPreferences? sharedPreferences;

  Future <Myservices> init() async{
    sharedPreferences =await SharedPreferences.getInstance();
    return this;
  } 

}

initialServices() async{
  print("initialServices running");
  await Get.putAsync(() => Myservices().init());
  print("initialServices done");
}