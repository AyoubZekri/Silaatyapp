String formatQuantity(num quantity) {
  if (quantity % 1 == 0) {
    return quantity.toInt().toString();
  }
  String str = quantity.toStringAsFixed(3);
  return str.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
}

String formavalue(num quantity) {
  if (quantity % 1 == 0) {
    return quantity.toInt().toString();
  }
  String str = quantity.toStringAsFixed(2);
  return str.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
}
