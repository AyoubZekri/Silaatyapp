import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class SignupData {
  Crud crud;
  SignupData(this.crud);

  postdata(String username, String password, String email, String phone,
      String confermPassword, String family_name) async {
    var response = await crud.postData(Applink.linkSignup, {
      "name": username,
      "password": password,
      "password_confirmation": confermPassword,
      'family_name': family_name,
      "email": email,
      "phone_number": phone,
    });
    return response.fold((l) => l, (r) => r);
  }
}
