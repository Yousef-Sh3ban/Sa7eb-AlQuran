import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surah_model.dart';

/// Repository for managing Surah data
class SurahRepository {
  List<SurahModel>? _cachedSurahs;

  /// Load all surahs from JSON
  Future<List<SurahModel>> getAllSurahs() async {
    if (_cachedSurahs != null) {
      return _cachedSurahs!;
    }

    final String jsonString =
        await rootBundle.loadString('assets/data/all_surahs.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> surahsJson = data['surahs'] as List<dynamic>;

    _cachedSurahs = surahsJson
        .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return _cachedSurahs!;
  }

  /// Get a single surah by ID
  Future<SurahModel?> getSurahById(int surahId) async {
    final List<SurahModel> surahs = await getAllSurahs();
    try {
      return surahs.firstWhere((s) => s.id == surahId);
    } catch (_) {
      return null;
    }
  }
}
