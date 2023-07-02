// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelData _$ModelDataFromJson(Map<String, dynamic> json) => ModelData(
      id: json['id'] as int?,
      nama_cabang: json['nama_cabang'] as String,
      deskripsi: json['deskripsi'] as String,
      sejarah: json['sejarah'] as String,
      gambar: json['gambar'] as String?,
    );

Map<String, dynamic> _$ModelDataToJson(ModelData instance) => <String, dynamic>{
      'id': instance.id,
      'nama_cabang': instance.nama_cabang,
      'deskripsi': instance.deskripsi,
      'sejarah': instance.sejarah,
      'gambar': instance.gambar,
    };
