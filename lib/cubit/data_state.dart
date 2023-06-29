import 'package:olahraga/model/sport_data.dart';

abstract class DataState {}

class InitialDataState extends DataState {}

class LoadingDataState extends DataState {}

class FailureAllLoadingDataState extends DataState {
  final String errorMessage;

  FailureAllLoadingDataState(this.errorMessage);

  @override
  String toString() {
    return 'FailureLoadingDataState{errorMessage: $errorMessage}';
  }
}

class SuccessAllLoadingDataState extends DataState {
  final List<ModelData> listDatas;
  final String message;

  SuccessAllLoadingDataState(this.listDatas, {required this.message});

  @override
  String toString() {
    return 'SuccessAllLoadingDataState{listDatas: $listDatas, message: $message}';
  }
}

class FailureSubmitDataState extends DataState {
  final String errorMessage;

  FailureSubmitDataState(this.errorMessage);

  @override
  String toString() {
    return 'FailureSubmitDataState{errorMessage: $errorMessage}';
  }
}

class SuccessSubmitDataState extends DataState {}

class FailureDeleteDataState extends DataState {
  final String errorMessage;

  FailureDeleteDataState(this.errorMessage);

  @override
  String toString() {
    return 'FailureDeleteDataState{errorMessage: $errorMessage}';
  }
}