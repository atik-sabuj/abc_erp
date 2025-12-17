import 'dart:convert';
import 'package:flutter/services.dart';

class LocalJsonService {
  static Future<Map<String, dynamic>> loadCompanyData() async {
    final jsonString =
    await rootBundle.loadString('assets/data.json');
    return json.decode(jsonString);
  }
}
