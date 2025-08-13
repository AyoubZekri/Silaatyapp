import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class NotificationData {
  Crud crud;

  NotificationData(this.crud);

  deleteNotification(Map data) async {
    var response = await crud.postDataheaders(Applink.deleteNotification, data);
    return response.fold((l) => l, (r) => r);
  }

  ShwoNotification() async {
    var response = await crud.getData(Applink.notification);
    return response.fold((l) => l, (r) => r);
  }

  ShwoinfoNotification(Map data) async {
    var response = await crud.postDataheaders(Applink.shwoinfoNotification, data);
    return response.fold((l) => l, (r) => r);
  }
}
