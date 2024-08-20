import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/theme/failure/failuer.dart';
import 'package:client/features/home/models/songModel.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, List<Songmodel>>> getAllFavSongs(
      {required String token}) async {
    try {
      List<Songmodel> songs = [];
      final res = await http.get(
          Uri.parse('${ServerConstants.serverUrl}/song/list/favourites'),
          headers: {
            'Content-type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      for (final map in resBodyMap) {
        songs.add(Songmodel.fromMap(map['song']));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong(
      {required String token, required String songId}) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/song/favourite'),
        headers: {
          'Content-type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            "song_id": songId,
          },
        ),
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        return Left(
          AppFailure(
            resBodyMap['detail'],
          ),
        );
      }

      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, String>> uploadSong(
      {required File selectedAudio,
      required File selectedImage,
      required String artistName,
      required String songName,
      required String token,
      required String hexCode}) async {
    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.serverUrl}/song/upload'),
      );

      req
        ..files.addAll(
          [
            await http.MultipartFile.fromPath('song', selectedAudio.path),
            await http.MultipartFile.fromPath('thumbnail', selectedImage.path)
          ],
        )
        ..fields.addAll(
          {
            'artist': artistName,
            'song_name': songName,
            'hex_code': hexCode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        );

      final res = await req.send();

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<Songmodel>>> getAllSongs(
      {required String token}) async {
    try {
      List<Songmodel> songs = [];
      final res = await http
          .get(Uri.parse('${ServerConstants.serverUrl}/song/list'), headers: {
        'Content-type': 'application/json',
        'x-auth-token': token,
      });

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;

      for (final map in resBodyMap) {
        songs.add(Songmodel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
