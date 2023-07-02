// import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:olahraga/model/sport_data.dart';
import 'package:olahraga/model/sport_user.dart';

class DioHelper {
  Dio? _dio;

  DioHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://rekano.com/'
      ),
    );
    _dio?.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<Either<String, List<ModelData>>> getAllData() async {
    try {
      var response = await _dio?.get('list/');
      var listDataOlahraga = List<ModelData>.from(
        response?.data.map((e) => ModelData.fromJson(e))
      );
      return Right(listDataOlahraga);
    } catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> addData(ModelData modelData) async {
    try {
      var formData = FormData.fromMap({
        'nama_cabang': modelData.nama_cabang,
        'deskripsi': modelData.deskripsi,
        'sejarah': modelData.sejarah,
      });
      
      await _dio?.post(
        'add/',
        data: formData,
      );
      return const Right(true);
    } catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> editData(ModelData modelData) async {
    try {
      var formData = FormData();
      formData.fields.addAll([
        MapEntry('id', modelData.id.toString()),
        MapEntry('nama_cabang', modelData.nama_cabang),
        MapEntry('deskripsi', modelData.deskripsi),
        MapEntry('sejarah', modelData.sejarah)
      ]);

      // if (imageFile != null) {
      //   formData.files.add(
      //     MapEntry('gambar', await MultipartFile.fromFile(imageFile.path))
      //   );
      // }
      _dio?.put(
        'update/${modelData.id}/',
        data: modelData.toJson(),
      );
      return const Right(true);
    } catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> deleteData(int id) async {
    try {
      _dio?.delete(
        'delete/$id/'
      );
      return const Right(true);
    } catch (error) {
      return Left('$error');
    }
  }

  Future login(String username, String password) async {
    var formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

    try {
      Response response = await _dio!.post(
        'user/login/',
        data: formData
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (error) {
      return error;
    }
  }

  Future registerUser(Map<String, dynamic>? userProfile) async {
    try {
      Response? response = await _dio?.post(
        'user/register/',
        data: userProfile
      );
      if (response?.statusCode == 200) {
        return response?.data;
      }
    } catch (error) {
      return error;
    }
  }

  Future<Object> getUserProfile(String id) async {
    try {
      var response = await _dio?.get('user/profile/');
      var listUserProfile = List<UserProfile>.from(
        response?.data.map((e) => UserProfile.fromJson(e))
      );
      return Right(listUserProfile);
    } catch (error) {
      return Left('$error');
    }
  }

  Future logout(String accessToken) async {
    try {
      Response? response = await _dio?.get(
        'user/logout/'
      );
      return response?.data;
    } catch (e) {
      return Left('$e');
    }
  }
}