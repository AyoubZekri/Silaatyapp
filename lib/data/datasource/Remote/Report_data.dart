import 'package:Silaaty/LinkApi.dart';
import 'package:Silaaty/core/class/Crud.dart';

class ReportData {
  Crud crud;

  ReportData(this.crud);

  addReport(Map data) async {
    var response = await crud.postDataheaders(Applink.addReport, data);
    return response.fold((l) => l, (r) => r);
  }

  EditReport(Map data) async {
    var response = await crud.postDataheaders(Applink.updatrReport, data);
    return response.fold((l) => l, (r) => r);
  }

  deleteReport(Map data) async {
    var response = await crud.postDataheaders(Applink.deleteReport, data);
    return response.fold((l) => l, (r) => r);
  }

  ShwoReport() async {
    var response = await crud.getData(Applink.Report);
    return response.fold((l) => l, (r) => r);
  }

  ShwoinfoReport(Map data) async {
    var response = await crud.postDataheaders(Applink.ShwoinfoReport, data);
    return response.fold((l) => l, (r) => r);
  }
}
