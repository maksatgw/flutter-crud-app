// ignore_for_file: unnecessary_this

class ProductModel {
  int? id;
  String? brand;
  String? model;
  int? price;
  int? stock;

  ProductModel({this.id, this.brand, this.model, this.price, this.stock});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    model = json['model'];
    price = json['price'];
    stock = json['stock'];
  }

  //Put ederken servise id gondermem gerektigi icin toJson icinde aid var
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['price'] = this.price;
    data['stock'] = this.stock;
    return data;
  }

  //Backendimde post ederken id auto increment olduğu için toJson id olmayan gönderiyoruz.
  Map<String, dynamic> toJsonPost() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['price'] = this.price;
    data['stock'] = this.stock;
    return data;
  }
}
