import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:client/features/home/models/fav_song.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String email;
  final String token;
  final List<FavSong> favourites;
  final String id;
  UserModel({
    required this.name,
    required this.email,
    required this.token,
    required this.favourites,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'token': token,
      'favourites': favourites.map((x) => x.toMap()).toList(),
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      favourites: List<FavSong>.from(
        (map['favourites'] ?? []).map<FavSong>(
          (x) => FavSong.fromMap(x as Map<String, dynamic>),
        ),
      ),
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? name,
    String? email,
    String? token,
    List<FavSong>? favourites,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      favourites: favourites ?? this.favourites,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, token: $token, favourites: $favourites, id: $id)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.token == token &&
        listEquals(other.favourites, favourites) &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        token.hashCode ^
        favourites.hashCode ^
        id.hashCode;
  }
}
