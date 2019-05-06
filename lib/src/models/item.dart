import 'dart:io';

class Item {
  static final String collection = 'item';
  String id;
  File image;
  String urlImage;
  String name;
  String description;
  double value = 0.00;

  Item();

  void setImage(File image) {
    this.image = image;
  }

  Item.fromJson(Map<String, dynamic> json)
      : urlImage = json['urlImage'],
        name = json['name'],
        description = json['description'],
        value = json['value'].toDouble();

  Map<String, dynamic> toJson() => {
    'urlImage': urlImage,
    'name': name,
    'description': description,
    'value': value
  };
}