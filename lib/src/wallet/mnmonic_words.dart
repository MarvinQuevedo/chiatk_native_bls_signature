import 'package:flutter/services.dart';

Future<List<String>> mnmonicWords() async {
  final strData = await rootBundle
      .loadString("packages/chiatk_bls_signature/assets/english.txt");
  return strData
      .split("\n")
      .where((element) => element.trim().isNotEmpty)
      .toList();
}
