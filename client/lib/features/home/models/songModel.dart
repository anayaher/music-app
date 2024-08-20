// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Songmodel {
  final String id;
  final String song_name;
  final String artist;
  final String thumbnail_url;
  final String hex_code;
  final String song_url;
  Songmodel({
    required this.id,
    required this.song_name,
    required this.artist,
    required this.thumbnail_url,
    required this.hex_code,
    required this.song_url,
  });

  Songmodel copyWith({
    String? id,
    String? song_name,
    String? artist,
    String? thubmnail_url,
    String? hex_code,
    String? song_url,
  }) {
    return Songmodel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      artist: artist ?? this.artist,
      thumbnail_url: thubmnail_url ?? this.thumbnail_url,
      hex_code: hex_code ?? this.hex_code,
      song_url: song_url ?? this.song_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': song_name,
      'artist': artist,
      'thumbnail_url': thumbnail_url,
      'hex_code': hex_code,
      'song_url': song_url,
    };
  }

  factory Songmodel.fromMap(Map<String, dynamic> map) {
    return Songmodel(
      id: map['id'] ?? '',
      song_name: map['song_name'] ?? '',
      artist: map['artist'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      hex_code: map['hex_code'] ?? '',
      song_url: map['song_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Songmodel.fromJson(String source) =>
      Songmodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Songmodel(id: $id, song_name: $song_name, artist: $artist, thubmnail_url: $thumbnail_url, hex_code: $hex_code, song_url: $song_url)';
  }

  @override
  bool operator ==(covariant Songmodel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_name == song_name &&
        other.artist == artist &&
        other.thumbnail_url == thumbnail_url &&
        other.hex_code == hex_code &&
        other.song_url == song_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        song_name.hashCode ^
        artist.hashCode ^
        thumbnail_url.hashCode ^
        hex_code.hashCode ^
        song_url.hashCode;
  }
}
