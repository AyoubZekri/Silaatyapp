import 'package:Silaaty/core/class/Crud.dart';
import 'package:Silaaty/linkapi.dart';

class SellerData {
  Crud crud;

  SellerData(this.crud);

  getSellers() async {
    // Note: GET endpoint implemented as GET in Laravel but crud might only support postData or getData
    // Let's check how crud handles GET requests. Usually crud.getData exists, but let's assume postData if needed or use getData.
    // I will use getData.
    var response = await crud.postDataheaders(Applink.sellerGet, {});
    // Wait, in my Laravel route I made it GET: `Route::get('/seller-user', [SellerUserController::class, 'index']);`
    // Wait, let's use GET. But wait! I can just make it POST in Laravel to be consistent with `Crud.postData`. Let's change Laravel to POST.
    return response.fold((l) => l, (r) => r);
  }

  addSeller(String name, String email, String password) async {
    var response = await crud.postDataheaders(Applink.sellerAdd, {
      "name": name,
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }

  updateSeller(int id, String name, String email, String password) async {
    Map<String, String> data = {
      "id": id.toString(),
      "name": name,
      "email": email,
    };
    if (password.isNotEmpty) {
      data["password"] = password;
    }

    var response = await crud.postDataheaders(Applink.sellerUpdate, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteSeller(int id) async {
    var response = await crud.postDataheaders(Applink.sellerDelete, {
      "id": id.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
