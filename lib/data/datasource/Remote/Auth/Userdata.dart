import 'dart:io';

import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class Userdata {
  Crud crud;
  Userdata(this.crud);

  updateuser(
    String username,
    String phone,
    String family_name,
    String adresse,
    File? file,
  ) async {
    var response;

    if (file == null) {
      response = await crud.postDataheaders(Applink.updateUser, {
        "name": username,
        'family_name': family_name,
        "phone_number": phone,
        "adresse": adresse,
      });
    } else {
      response = await crud.addRequestWithImageOne(
          Applink.updateUser,
          {
            "name": username,
            'family_name': family_name,
            "phone_number": phone,
            "adresse": adresse,
          },
          file,
          "logo_stor");
    }

    return response.fold((l) => l, (r) => r);
  }
}
