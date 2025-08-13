import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class ZakatData {
  Crud crud;
  ZakatData(this.crud);

  GetZakat() async {
    var response = await crud.getData(Applink.Zakat);
    return response.fold((l) => l, (r) => r);
  }

  GetProdactZakat() async {
    var response = await crud.getData(Applink.shwoproductZakat);
    return response.fold((l) => l, (r) => r);
  }


    addcashliquidity(Map data) async {
    var response = await crud.postDataheaders(Applink.cashliquidity,data);
    return response.fold((l) => l, (r) => r);
  }


}
