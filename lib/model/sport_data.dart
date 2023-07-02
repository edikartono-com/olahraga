import 'package:json_annotation/json_annotation.dart';

part 'sport_data.g.dart';

@JsonSerializable()
class ModelData {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'nama_cabang')
  final String nama_cabang;

  @JsonKey(name: 'deskripsi')
  final String deskripsi;

  @JsonKey(name: 'sejarah')
  final String sejarah;

  @JsonKey(name: 'gambar')
  final String? gambar;

  ModelData({
    this.id,
    required this.nama_cabang,
    required this.deskripsi,
    required this.sejarah,
    this.gambar
  });

  factory ModelData.fromJson(Map<String, dynamic> json) => _$ModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$ModelDataToJson(this);

  @override
  String toString() {
    return 'ModelData{id: $id, nama_cabang: $nama_cabang, deskripsi: $deskripsi, sejarah: $sejarah, gambar: $gambar}';
  }
}