// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurahModel _$SurahModelFromJson(Map<String, dynamic> json) => SurahModel(
  id: (json['id'] as num).toInt(),
  nameArabic: json['name_arabic'] as String,
  nameEnglish: json['name_english'] as String,
  revelationType: json['revelation_type'] as String,
  totalAyahs: (json['total_ayahs'] as num).toInt(),
  orderNumber: (json['order_number'] as num).toInt(),
);

Map<String, dynamic> _$SurahModelToJson(SurahModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_arabic': instance.nameArabic,
      'name_english': instance.nameEnglish,
      'revelation_type': instance.revelationType,
      'total_ayahs': instance.totalAyahs,
      'order_number': instance.orderNumber,
    };
