
import 'dart:convert';

class Planet {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final bool? isDestroyed;

  Planet({
    this.id,
    this.name,
    this.image,
    this.description,
    this.isDestroyed,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      isDestroyed: json['isDestroyed'],
    );
  }
}

class Transformation {
  final int? id;
  final String? name;
  final String? image;

  Transformation({this.id, this.name, this.image});

  factory Transformation.fromJson(Map<String, dynamic> json) {
    return Transformation(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Character {
  final int id;
  final String name;
  final String? race;
  final String? gender;
  final String? affiliation;
  final String? description;
  final String? image;
  final Planet? originPlanet;
  final List<Transformation>? transformations;

  Character({
    required this.id,
    required this.name,
    this.race,
    this.gender,
    this.affiliation,
    this.description,
    this.image,
    this.originPlanet,
    this.transformations,
  });

 
  factory Character.fromJson(Map<String, dynamic> json) {
    List<Transformation>? trans;
    if (json['transformations'] != null && json['transformations'] is List) {
      trans = (json['transformations'] as List)
          .map((e) => Transformation.fromJson(e))
          .toList();
    }
    Planet? planet;
    if (json['originPlanet'] != null && json['originPlanet'] is Map) {
      planet = Planet.fromJson(json['originPlanet']);
    }
    return Character(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      race: json['race'],
      gender: json['gender'],
      affiliation: json['affiliation'],
      description: json['description'],
      image: json['image'],
      originPlanet: planet,
      transformations: trans,
    );
  }


  static List<Character> listFromJson(dynamic jsonList) {
    if (jsonList == null) return [];
    return (jsonList as List).map((e) => Character.fromJson(e)).toList();
  }

  @override
  String toString() => 'Character($id, $name)';
}