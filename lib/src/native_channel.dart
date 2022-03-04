import 'dart:io';

import 'bls/bls_ffi_generic.dart';
import 'bls/bls_ffi_ios.dart';
import 'bls/bls_platform.dart';

export 'wallet/mnmonic_words.dart';

class ChiatkBlsSignatureNative {
  static final BlsPlatform platform = _findPlatform;

  static BlsPlatform get _findPlatform {
    /*  if (kIsWeb) {
      // return BlsWeb();
    } */
    if (Platform.isAndroid) {
      return BlsFfiGeneric();
    } else if (Platform.isIOS) {
      return BlsFFIiOS();
    }
    return BlsFfiGeneric();
  }
}
