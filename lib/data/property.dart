
import 'dart:convert';

class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> imagesUrl;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imagesUrl,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      imagesUrl: List<String>.from(json['imagesUrl']),
    );
  }
}

List<Property> parseProperties(String responseBody) {
  final parsed = jsonDecode(responseBody)['allProperty'].cast<Map<String, dynamic>>();
  return parsed.map<Property>((json) => Property.fromJson(json)).toList();
}

