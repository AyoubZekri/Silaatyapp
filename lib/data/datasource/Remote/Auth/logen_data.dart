import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);

  postdata(String password, String email, String fcm_Token) async {
    var response = await crud.postData(Applink.login, {
      "email": email,
      "password": password,
      "fcm_token": fcm_Token,
    });
    return response.fold((l) => l, (r) => r);
  }

  logout() async {
    var response = await crud.postDataheadersLogout(Applink.logout);
    return response.fold((l) => l, (r) => r);
  }

  getUser() async {
    var response = await crud.getData(Applink.getUser);
    return response.fold((l) => l, (r) => r);
  }
}
