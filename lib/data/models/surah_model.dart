import 'package:json_annotation/json_annotation.dart';

part 'surah_model.g.dart';

/// Surah data model.
///
/// Represents a Quranic chapter with its metadata.
@JsonSerializable()
class SurahModel {
  final int id;
  @JsonKey(name: 'name_arabic')
  final String nameArabic;
  @JsonKey(name: 'name_english')
  final String nameEnglish;
  @JsonKey(name: 'revelation_type')
  final String revelationType;
  @JsonKey(name: 'total_ayahs')
  final int totalAyahs;
  @JsonKey(name: 'order_number')
  final int orderNumber;

  const SurahModel({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.revelationType,
    required this.totalAyahs,
    required this.orderNumber,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) =>
      _$SurahModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurahModelToJson(this);

  bool get isMakki => revelationType == 'مكية';
}
