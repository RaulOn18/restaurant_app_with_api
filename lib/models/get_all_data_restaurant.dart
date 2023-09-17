// To parse this JSON data, do
//
//     final getAllRestaurant = getAllRestaurantFromJson(jsonString);

import 'dart:convert';

GetAllRestaurant getAllRestaurantFromJson(String str) =>
    GetAllRestaurant.fromJson(json.decode(str));

String getAllRestaurantToJson(GetAllRestaurant data) =>
    json.encode(data.toJson());

class GetAllRestaurant {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  GetAllRestaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory GetAllRestaurant.fromJson(Map<String, dynamic> json) =>
      GetAllRestaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
