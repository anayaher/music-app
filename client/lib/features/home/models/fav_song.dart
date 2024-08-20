// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FavSong {
  final String id;
  final String song_id;
  final String user_id;
  FavSong({
    required this.id,
    required this.song_id,
    required this.user_id,
  });

  FavSong copyWith({
    String? id,
    String? song_id,
    String? user_id,
  }) {
    return FavSong(
      id: id ?? this.id,
      song_id: song_id ?? this.song_id,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_id': song_id,
      'user_id': user_id,
    };
  }

  factory FavSong.fromMap(Map<String, dynamic> map) {
    return FavSong(
      id: map['id'] ?? '',
      song_id: map['song_id'] ?? '',
      user_id: map['user_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FavSong.fromJson(String source) => FavSong.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FavSong(id: $id, song_id: $song_id, user_id: $user_id)';

  @override
  bool operator ==(covariant FavSong other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.song_id == song_id &&
      other.user_id == user_id;
  }

  @override
  int get hashCode => id.hashCode ^ song_id.hashCode ^ user_id.hashCode;
}
