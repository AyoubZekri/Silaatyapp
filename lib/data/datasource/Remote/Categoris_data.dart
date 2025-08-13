import 'dart:io';

import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class CategorisData {
  Crud crud;

  CategorisData(this.crud);

  viewdata() async {
    var response = await crud.getData(Applink.CategoriesGet);
    return response.fold((l) => l, (r) => r);
  }

  Adddata(Map data, [File? file])async {
    var response = await crud.addRequestWithImageOne(Applink.Addcat,data,file);
    return response.fold((l) => l, (r) => r);
  }


  Updatecat(Map data, [File? file]) async {
    var response;
    if (file == null) {
      response = await crud.postDataheaders(Applink.EditCat, data);
    } else {
      response =
          await crud.addRequestWithImageOne(Applink.EditCat, data, file);
    }
    ;
    return response.fold((l) => l, (r) => r);
  }


  deletecat(Map data) async {
    var response = await crud.postDataheaders(Applink.Deletecat, data);
    return response.fold((l) => l, (r) => r);
  }

}