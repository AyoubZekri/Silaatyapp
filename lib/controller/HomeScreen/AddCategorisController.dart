import 'package:Silaaty/core/class/Statusrequest.dart';
import 'package:Silaaty/core/functions/handlingdatacontroller.dart';
import 'package:Silaaty/core/services/Services.dart';
import 'package:Silaaty/data/datasource/Remote/Categoris_data.dart';
import 'package:Silaaty/data/model/Categoris_model.dart';
import 'package:get/get.dart';

class Addcategoriscontroller extends GetxController {
  CategorisData categorisData = CategorisData(Get.find());

  Myservices myservices = Get.find();

  List<Catdata> categories = [];
  Statusrequest statusrequest = Statusrequest.none;


  getCategoris() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await categorisData.viewdata();
    print("============================================== $response");
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      final model = Categoris_Model.fromJson(response);
      categories = model.data?.catdata ?? [];
    } else {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

}