import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:olahraga/cubit/data_cubit.dart';
import 'package:olahraga/cubit/data_state.dart';
import 'package:olahraga/helper/dio_helper.dart';
import 'package:olahraga/ui/add_edit_data.dart';
import 'package:olahraga/ui/login.dart';
import 'package:olahraga/ui/profile_data.dart';

FlutterSecureStorage? secureStorage;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListDataPage(),
    );
  }
}

class ListDataPage extends StatefulWidget {
  const ListDataPage({Key? key}) : super(key: key);

  @override
  State<ListDataPage> createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final dioHelper = DioHelper();
  late DataCubit? dataCubit;

  @override
  void initState() {
    dataCubit = DataCubit(DioHelper());
    dataCubit?.getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: const Text('Sports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen()
                )
              );
              if (result != null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileData(accessToken: result.accessToken)
                  )
                );
              }
            },
          )
        ],
      ),
      body: BlocProvider<DataCubit>(
        create: (_) => dataCubit!,
        child: BlocListener<DataCubit, DataState>(
          listener: (_, state) {
            if (state is FailureAllLoadingDataState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is FailureDeleteDataState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is SuccessAllLoadingDataState) {
              if (state.message.isNotEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message))
                );
              }
            }
          },
          child: BlocBuilder<DataCubit, DataState>(
            builder: (_, state) {
              if (state is LoadingDataState) {
                return Center(
                  child: Platform.isIOS 
                  ? const CupertinoActivityIndicator() 
                  : const CircularProgressIndicator(),
                );
              } else if (state is FailureAllLoadingDataState) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is SuccessAllLoadingDataState) {
                var listDatas = state.listDatas;

                return GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(16),
                  children: List.generate(listDatas.length, (index) {
                    var modelData = listDatas[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (modelData.gambar != null) 
                              Image.network(
                                modelData.gambar!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            else
                              Image.asset(
                                'lib/assets/images/no-image.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                          ],
                        )
                      ),
                    );
                  }),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditData(modelData: null),
            ),
          );
          if (result != null) {
            dataCubit?.getAllData();
          }
        },
      ),
    );
  }
}
