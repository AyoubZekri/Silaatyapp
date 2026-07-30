import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);

  postdata(String password, String email, String fcm_Token, bool isSeller) async {
    String url = isSeller ? Applink.loginSeller : Applink.login;
    var response = await crud.postData(url, {
      "email": email,
      "password": password,
      if (isSeller) "fcm_token": fcm_Token,
    });
    return response.fold((l) => l, (r) => r);
  }

  logout() async {
    var response = await crud.postDataheadersLogout(Applink.logout);
    return response.fold((l) => l, (r) => r);
  }

  getUser(bool isSeller) async {
    String url = isSeller ? Applink.getSellerUser : Applink.getUser;
    var response = await crud.getData(url);
    return response.fold((l) => l, (r) => r);
  }
}
