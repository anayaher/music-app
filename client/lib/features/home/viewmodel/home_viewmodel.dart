import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/fav_song.dart';
import 'package:client/features/home/models/songModel.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<Songmodel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<Songmodel>> getFavSongs(GetFavSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res =
      await ref.watch(homeRepositoryProvider).getAllFavSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
        token: ref.read(currentUserNotifierProvider)!.token, songId: songId);

    final val = switch (res) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId)
    };
    print(val);
  }

  AsyncValue _favSongSuccess(bool isFav, String songId) {
    final user = ref.read(currentUserNotifierProvider.notifier);

    if (isFav) {
      user.addUser(ref.read(currentUserNotifierProvider)!.copyWith(favourites: [
        ...ref.read(currentUserNotifierProvider)!.favourites,
        FavSong(id: '', song_id: songId, user_id: '')
      ]));
    } else {
      user.addUser(ref.read(currentUserNotifierProvider)!.copyWith(
            favourites: ref
                .read(currentUserNotifierProvider)!
                .favourites
                .where((fav) => fav.song_id != songId)
                .toList(),
          ));
    }

    return state = AsyncValue.data(isFav);
  }

  Future<void> uploadSongs(
      {required File selectedAudio,
      required File selectedImage,
      required String artistName,
      required String songName,
      required Color selectedColor}) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
        selectedAudio: selectedAudio,
        selectedImage: selectedImage,
        artistName: artistName,
        songName: songName,
        token: ref.read(currentUserNotifierProvider)!.token,
        hexCode: rbgToHex(selectedColor));

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r)
    };

    print(val);
  }

  List<Songmodel> getLocalSongs() {
    return _homeLocalRepository.loadSongs();
  }
}
