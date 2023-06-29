import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:olahraga/model/sport_data.dart';

class DioHelper {
  Dio? _dio;

  DioHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8001/'
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
      await _dio?.post(
        'add/',
        data: modelData.toJson(),
      );
      return const Right(true);
    } catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> editData(ModelData modelData) async {
    try {
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
}