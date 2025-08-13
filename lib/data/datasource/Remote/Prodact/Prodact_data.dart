import 'dart:io';

import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class ProdactData {
  Crud crud;
  ProdactData(this.crud);

  addProdact(Map data, [File? file]) async {
    var response;
    if (file == null) {
      response = await crud.postDataheaders(Applink.AddProdact, data);
    } else {
      response =
          await crud.addRequestWithImageOne(Applink.AddProdact, data, file);
    }
    ;
    return response.fold((l) => l, (r) => r);
  }

  UpdateProdact(Map data, [File? file]) async {
    var response;
    if (file == null) {
      response = await crud.postDataheaders(Applink.updateProdact, data);
    } else {
      response =
          await crud.addRequestWithImageOne(Applink.updateProdact, data, file);
    }
    ;
    return response.fold((l) => l, (r) => r);
  }

  Switchupdate(Map data) async {
    var response;
    response = await crud.postDataheaders(Applink.SwitchProdact, data);
    return response.fold((l) => l, (r) => r);
  }

  getProdact(Map data) async {
    var response = await crud.postDataheaders(Applink.GetCatProdact, data);
    return response.fold((l) => l, (r) => r);
  }

  search(Map data) async {
    var response = await crud.postDataheaders(Applink.Searchproduct, data);
    return response.fold((l) => l, (r) => r);
  }

  getCatProdactbytype(Map data) async {
    var response =
        await crud.postDataheaders(Applink.GetCatProdactbytype, data);
    return response.fold((l) => l, (r) => r);
  }

  ShwoProdact(Map data) async {
    var response = await crud.postDataheaders(Applink.ShwoProdact, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteProdact(Map data) async {
    var response = await crud.postDataheaders(Applink.deleteProdact, data);
    return response.fold((l) => l, (r) => r);
  }
}
