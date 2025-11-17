// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String model;
  String pk;
  Fields fields;

  Product({required this.model, required this.pk, required this.fields});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  int? user;
  String name;
  int price;
  int stock;
  String description;
  String? thumbnail;
  String category;
  bool isFeatured;

  Fields({
    this.user,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    this.thumbnail,
    required this.category,
    required this.isFeatured,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    name: json["name"],
    price: json["price"],
    stock: json["stock"],
    description: json["description"],
    thumbnail: json["thumbnail"],
    category: json["category"],
    isFeatured: json["is_featured"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "name": name,
    "price": price,
    "stock": stock,
    "description": description,
    "thumbnail": thumbnail,
    "category": category,
    "is_featured": isFeatured,
  };
}
