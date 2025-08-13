import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class Userdata {
  Crud crud;
  Userdata(this.crud);

  updateuser(String username, String phone, String family_name) async {
    var response = await crud.postDataheaders(Applink.updateUser, {
      "name": username,
      'family_name': family_name,
      "phone_number": phone,
    });
    return response.fold((l) => l, (r) => r);
  }
}
