import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class Invoicedata {
  Crud crud;

  Invoicedata(this.crud);

  addinvoice(Map data) async {
    var response = await crud.postDataheaders(Applink.addinvoice, data);
    return response.fold((l) => l, (r) => r);
  }

  Editinvoise(Map data) async {
    var response = await crud.postDataheaders(Applink.Editinvoise, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteinvoice(Map data) async {
    var response = await crud.postDataheaders(Applink.deleteinvoice, data);
    return response.fold((l) => l, (r) => r);
  }

  Shwoinvoice(Map data) async {
    var response = await crud.postDataheaders(Applink.Shwoinvoice, data);
    return response.fold((l) => l, (r) => r);
  }

  Shwoinfoinvoice(Map data) async {
    var response = await crud.postDataheaders(Applink.Shwoinfoinvoice, data);
    return response.fold((l) => l, (r) => r);
  }


   switchStatus(Map data) async {
    var response = await crud.postDataheaders(Applink.switchtransactions, data);
    return response.fold((l) => l, (r) => r);
  }
}
