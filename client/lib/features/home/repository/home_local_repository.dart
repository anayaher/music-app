import 'package:client/features/home/models/songModel.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadSongs(Songmodel song) {
    box.put(song.id, song.toJson());
  }

  List<Songmodel> loadSongs() {
    List<Songmodel> songs = [];
    for (final keys in box.keys) {
      songs.add(Songmodel.fromJson(box.get(keys)));
    }
    return songs;
  }
}
