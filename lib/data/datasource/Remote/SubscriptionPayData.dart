import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class SubscriptionPayData {
  Crud crud;
  SubscriptionPayData(this.crud);

  getpay() async {
    var response = await crud.getData(Applink.getpay);
    return response.fold((l) => l, (r) => r);
  }

  getstatus(int id) async {
    var response = await crud.getData("${Applink.server}/payments/$id/status");
    return response.fold((l) => l, (r) => r);
  }

  chargilycreate(Map data) async {
    var response = await crud.postDataheaders(Applink.chargilycreate, data);
    return response.fold((l) => l, (r) => r);
  }
}
