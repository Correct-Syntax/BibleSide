import 'dart:convert';
import 'package:flutter/services.dart';


Map<String, String> bookMapping = {
  'MAT': 'Matthew',
  'MRK': 'Mark',
  'LUK': 'Luke',
  'JHN': 'John',
  'ACT': 'Acts',
  'ROM': 'Romans',
  'CO1': '1 Corinthians',
  'CO2': '2 Corinthians',
  'GAL': 'Galatians',
  'EPH': 'Ephesians',
  'PHP': 'Philippians',
  'COL': 'Colossians',
  'TH1': '1 Thessalonians',
  'TH2': '2 Thessalonians',
  'TI1': '1 Timothy',
  'TI2': '2 Timothy',
  'TIT': 'Titus',
  'PHM': 'Philemon',
  'HEB': 'Hebrews',
  'JAM': 'James',
  'PE1': '1 Peter',
  'PE2': '2 Peter',
  'JN1': '1 John',
  'JN2': '2 John',
  'JN3': '3 John',
  'JDE': 'Jude',
  'REV': 'Revelation',
};


String bookCodeToBook(String bookCode) {
  return bookMapping[bookCode]!;
}

String bookToBookCode(String book) {
  return bookMapping.keys.firstWhere((item) => bookMapping[item] == book);
}



class ReaderText {
  ReaderText(this.bibleCode, this.versionCode, this.bookCode);

  String bibleCode;
  String versionCode;
  String bookCode;


  void setBibleCode(String code) {
    bibleCode = bibleCode;
  }

  void setVersionCode(String code) {
    versionCode = versionCode;
  }

  void setBookCode(String code) {
    bookCode = bookCode;
  }


  Future<Map<String, dynamic>> loadJson() async {
    String path = 'assets/$bibleCode/$versionCode/$bookCode.json';
    return await loadJsonFromPath(path);
  }

  Future<Map<String, dynamic>> loadJsonFromPath(String path) async {
    final String data = await rootBundle.loadString(path);
    return json.decode(data);
  }
}
