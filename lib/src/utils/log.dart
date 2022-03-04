import 'dart:core' as core;

import 'package:flutter/foundation.dart';

class Log {
  Log._();
  static void print(object) {
    if (kDebugMode) {
      core.print(object);
    }
  }
}
