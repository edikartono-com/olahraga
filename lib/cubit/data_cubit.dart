import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olahraga/cubit/data_state.dart';
import 'package:olahraga/helper/dio_helper.dart';
import 'package:olahraga/model/sport_data.dart';

class DataCubit extends Cubit<DataState> {
  final DioHelper dioHelper;

  DataCubit(this.dioHelper) : super(InitialDataState());

  void getAllData() async {
    emit(LoadingDataState());
    var result = await dioHelper.getAllData();
    result.fold(
      (errorMessage) => emit(FailureAllLoadingDataState(errorMessage)),
      (listDatas) => emit(
        SuccessAllLoadingDataState(listDatas, message: 'All data loaded')
      ),
    );
  }

  void addData(ModelData modelData) async {
    emit(LoadingDataState());
    var result = await dioHelper.addData(modelData);
    var resultAddFold = result.fold(
      (errorMessage) => errorMessage,
      (response) => response
    );
    if (resultAddFold is String) {
      (errorMessage) => emit(FailureSubmitDataState(
        'Data Tidak berhasil disimpan'
      ));
    }
    var resultGetAllData = await dioHelper.getAllData();
    resultGetAllData.fold(
      (errorMessage) => emit(FailureSubmitDataState(errorMessage)),
      (_) => emit(SuccessSubmitDataState())
    );
    getAllData();
  }

  void editData(ModelData modelData) async {
    emit(LoadingDataState());
    var result = await dioHelper.editData(modelData);
    var resultAddFold = result.fold(
      (errorMessage) => errorMessage,
      (response) => response
    );
    if (resultAddFold is String) {
      (errorMessage) => emit(FailureSubmitDataState(
        'Data Tidak berhasil disimpan'
      ));
    }
    var resultGetAllData = await dioHelper.getAllData();
    resultGetAllData.fold(
      (errorMessage) => emit(FailureSubmitDataState(errorMessage)),
      (_) => emit(SuccessSubmitDataState())
    );
    getAllData();
  }

  void deleteData(int id) async {
    emit(LoadingDataState());
    var resultDelete = await dioHelper.deleteData(id);
    var resultDeleteFold = resultDelete.fold(
      (errorMessage) => errorMessage,
      (response) => response,
    );
    if (resultDeleteFold is String) {
      emit(FailureDeleteDataState(resultDeleteFold));
      return;
    }
    var resultGetAllData = await dioHelper.getAllData();
    resultGetAllData.fold(
      (errorMessage) => emit(FailureAllLoadingDataState(errorMessage)),
      (listDatas) {
        emit(SuccessAllLoadingDataState(
          listDatas,
          message: 'Data deleted successfully'
        ));
        getAllData();
      }
    );
  }
}