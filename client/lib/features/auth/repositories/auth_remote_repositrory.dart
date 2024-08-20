import 'dart:convert';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/theme/failure/failuer.dart';
import 'package:client/core/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repositrory.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.serverUrl}/auth/signup'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login(
      {required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${ServerConstants.serverUrl}/auth/login',
        ),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromMap(resBodyMap['user'])
          .copyWith(token: resBodyMap['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUser(String token) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${ServerConstants.serverUrl}/auth/',
        ),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
