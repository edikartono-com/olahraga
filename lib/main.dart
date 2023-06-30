import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olahraga/cubit/data_cubit.dart';
import 'package:olahraga/cubit/data_state.dart';
import 'package:olahraga/helper/dio_helper.dart';
import 'package:olahraga/ui/add_edit_data.dart';

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
  _ListDataPageState createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
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
        title: const Text('Flutter CRUD Cubit'),
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
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listDatas.length,
                  itemBuilder: (_, index) {
                    var modelData = listDatas[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modelData.nama_cabang,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              modelData.deskripsi,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              modelData.sejarah,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red
                                  ),
                                  onPressed: () async {
                                    var dialogConfirmDelete = Platform.isIOS ? await showCupertinoDialog<bool>(
                                      context: context,
                                      builder: (_) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Warning'),
                                          content: Text(
                                            'Are you sure want to delete ${modelData.nama_cabang}\'s data?'
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              isDefaultAction: true,
                                              child: const Text('Delete'),
                                            ),
                                            CupertinoDialogAction(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    )
                                    : await showDialog<bool>(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text('Warning'),
                                          content: Text(
                                            'Are you sure want to delete ${modelData.nama_cabang}\'s data?'
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    );
                                    if (dialogConfirmDelete != null && dialogConfirmDelete) {
                                      dataCubit?.deleteData(modelData.id!);
                                    }
                                  }, child: const Text('DELETE'),
                                ),
                                TextButton(
                                  child: const Text('EDIT'),
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditData(
                                          modelData: modelData,
                                        )
                                      )
                                    );
                                    if (result != null) {
                                      dataCubit?.getAllData();
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
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
              builder: (_) => const AddEditData(),
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
