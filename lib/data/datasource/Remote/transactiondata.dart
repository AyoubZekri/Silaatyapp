import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class Transactiondata {
  Crud crud;

  Transactiondata(this.crud);

  addtransaction(Map data) async {
    var response = await crud.postDataheaders(Applink.addtransaction, data);
    return response.fold((l) => l, (r) => r);
  }

  Edittransaction(Map data) async {
    var response = await crud.postDataheaders(Applink.Edittransaction, data);
    return response.fold((l) => l, (r) => r);
  }

  deletetransaction(Map data) async {
    var response = await crud.postDataheaders(Applink.deletetransaction, data);
    return response.fold((l) => l, (r) => r);
  }

  Shwotransaction(Map data) async {
    var response = await crud.postDataheaders(Applink.transaction, data);
    return response.fold((l) => l, (r) => r);
  }
}
