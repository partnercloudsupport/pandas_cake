import 'dart:io';

class Item {
  final String collection = 'item';
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
        value = json['value'];

  Map<String, dynamic> toJson() => {
    'urlImage': urlImage,
    'name': name,
    'description': description,
    'value': value
  };
}