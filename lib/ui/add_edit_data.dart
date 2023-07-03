import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olahraga/cubit/data_cubit.dart';
import 'package:olahraga/cubit/data_state.dart';
import 'package:olahraga/helper/dio_helper.dart';
import 'package:olahraga/model/sport_data.dart';
// import 'package:image_picker/image_picker.dart';

class AddEditData extends StatefulWidget  {
  final ModelData? modelData;

  const AddEditData({super.key, this.modelData});

  @override
  _AddEditDataState createState() => _AddEditDataState();
}

class _AddEditDataState extends State<AddEditData> {
  final dataCubit = DataCubit(DioHelper());
  final scaffoldState = GlobalKey<ScaffoldState>();
  final formSate = GlobalKey<FormState>();
  final focusNodeButtonSubmit = FocusNode();

  var controllerNama = TextEditingController();
  var controllerDeskripsi = TextEditingController();
  var controllerSejarah = TextEditingController();

  var isEdit = false;
  var isSuccess = false;

  // late File? imageFile;

  @override
  void initState() {
    isEdit = widget.modelData != null;
    if (isEdit) {
      controllerNama.text = widget.modelData!.nama_cabang;
      controllerDeskripsi.text = widget.modelData!.deskripsi;
      controllerSejarah.text = widget.modelData!.sejarah;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSuccess) {
          Navigator.pop(context, true);
        }
        return true;
      },
      child: Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text(
            widget.modelData == null ? 'Add Data': 'Edit Data'
          ),
        ),
        body: BlocProvider<DataCubit>(
          create: (_) => dataCubit,
          child: BlocListener<DataCubit, DataState>(
            listener: (_, state) {
              if (state is SuccessSubmitDataState) {
                isSuccess = true;

                if (isEdit) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data added successfully'),
                    )
                  );
                  setState(() {
                    controllerNama.clear();
                    controllerDeskripsi.clear();
                    controllerSejarah.clear();
                  });
                  Navigator.pop(context, true);
                }
              } else if (state is FailureSubmitDataState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage))
                );
              }
            },
            child: Stack(
              children: [
                _buildWidgetForm(),
                _buildWidgetLoading()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetForm() {
    return Form(
      key: formSate,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controllerNama,
              decoration: const InputDecoration(labelText: 'Nama Cabang'),
              validator: (value) {
                return value == null || value.isEmpty ? 'Enter Nama Cabang' : null;
              },
              keyboardType: TextInputType.name,
            ),
            TextField(
              maxLines: 3,
              controller: controllerDeskripsi,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              keyboardType:  TextInputType.text,
            ),
            TextField(
              controller:  controllerSejarah,
              decoration: const InputDecoration(labelText: 'Sejarah'),
              keyboardType: TextInputType.text,
            ),
            // ElevatedButton(
            //   onPressed: _pickImage,
            //   child: const Text('Choose Image'),
            // ),
            // // ignore: unnecessary_null_comparison
            // if (imageFile != null) Image.file(imageFile as File),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  )
                ),
                child: const Text('SUBMIT'),
                onPressed: () {
                  focusNodeButtonSubmit.requestFocus();
                  if (formSate.currentState!.validate()) {
                    var namaCabang = controllerNama.text.trim();
                    var deskripsi = controllerDeskripsi.text.trim();
                    var sejarah = controllerSejarah.text.trim();

                    if (isEdit) {
                      var modelData = ModelData(
                        id: widget.modelData!.id,
                        nama_cabang: namaCabang,
                        deskripsi: deskripsi,
                        sejarah: sejarah,
                      );
                      dataCubit.editData(modelData);
                    } else {
                      var modelData = ModelData(
                        nama_cabang: namaCabang,
                        deskripsi: deskripsi,
                        sejarah: sejarah,
                      );
                      dataCubit.addData(modelData);
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetLoading() {
      return BlocBuilder<DataCubit, DataState>(
        builder: (_, state) {
          if (state is LoadingDataState) {
            return Container(
              color: Colors.black.withOpacity(.5),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Platform.isIOS 
                ? const CupertinoActivityIndicator() 
                : const CircularProgressIndicator(),
              ),
            );
          } else {
            return Container();
          }
        },
      );
    }
}