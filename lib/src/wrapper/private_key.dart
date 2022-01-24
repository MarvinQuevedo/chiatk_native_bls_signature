import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/chiatk_bls_signature.dart';

import '../native_channel.dart';
import 'g1_elements.dart';
import 'g2_elements.dart';
import 'generic_key.dart';

class PrivateKey extends GenericKey {
  PrivateKey(Uint8List privateKeyBytes)
      : super(privateKeyBytes, obscureStringsPrints: true);

  /// call the native channels and get PrivateKey from Seed
  static PrivateKey fromSeed(Uint8List seed) {
    return ChiatkBlsSignatureNative.platform.augSchemeMPLKeyGen(seed)!;
  }

  /// is the same of call the constructor
  static PrivateKey fromBytes(Uint8List bytes) {
    return PrivateKey(bytes);
  }

  G1Element getG1Element() {
    return ChiatkBlsSignatureNative.platform.privateKeyGetG1Element(keyBytes!)!;
  }

  JacobianPoint getG1() {
    return JacobianPoint(getG1Element().keyBytes);
  }

  G2Element getG2Element() {
    return ChiatkBlsSignatureNative.platform.privateKeyGetG2Element(keyBytes!)!;
  }
}
