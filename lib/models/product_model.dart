class ProductModel {
  int id;
  String sku;
  String name;
  double price;
  String type_id;
  String image;

  ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    price = parsedJson['price'].toDouble();
    sku = parsedJson['sku'];
    type_id = parsedJson['type_id'];
    final customAttributes = parsedJson['custom_attributes'] as List<dynamic>;
    if (customAttributes != null) {
      final imageAttribute = customAttributes.firstWhere((element) {
        if (element['attribute_code'] == 'image') {
          return true;
        }
        return false;
      });
      if (imageAttribute != null) {
        image = imageAttribute['value'];
      }
    }
  }
}
