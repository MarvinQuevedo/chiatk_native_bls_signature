import 'package:chiatk_native_bls_signature/src/bls/bls_ffi_generic.dart';
import 'package:flutter/foundation.dart';

import 'dart:ffi';
import "dart:ffi" as ffi;
import 'ffi_functions_def.dart';

class BlsFFIiOS extends BlsFfiGeneric {
  @override
  Future<void> init() async {
    nativeLib = DynamicLibrary.process();

    final fn =
        lib.lookupFunction<BlsInitFunction, BlsInitFunctionDart>("Bls_Init");
    final result = fn.call();
    if (kDebugMode) {
      print("FFI init $result");
    }
  }
}
