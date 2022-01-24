import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/chiatk_bls_signature.dart';
import 'package:chiatk_native_bls_signature/src/native_channel.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/generic_key.dart';

class G1Element extends GenericKey {
  G1Element(Uint8List? keyBytes) : super(keyBytes);

  Future<int> getFingerprintFunction() async {
    return ChiatkBlsSignatureNative.platform
        .g1ElementGetFingerprint(g1ElementBytes: keyBytes!);
  }

  G2Element toG2Element() => G2Element(keyBytes);
}
