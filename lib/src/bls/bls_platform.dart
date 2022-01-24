import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/src/wrapper/g1_elements.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/g2_elements.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/private_key.dart';

abstract class BlsPlatform {
  /// Load native libraries and prepare for work
  void init();

  bool? test();

  PrivateKey? augSchemeMPLKeyGen(Uint8List seed);
  G1Element? privateKeyGetG1Element(Uint8List privateKeyBytes);
  G2Element? privateKeyGetG2Element(Uint8List privateKeyBytes);
  G2Element? augSchemeMPLSign({
    required Uint8List privateKeyBytes,
    required Uint8List messageBytes,
  });
  PrivateKey? augSchemeMPLDeriveChildSk({
    required Uint8List privateKeyBytes,
    required int index,
  });
  G1Element? augSchemeMPLDeriveChildPkUnhardened({
    required Uint8List g1ElementBytes,
    required int index,
  });
  PrivateKey? augSchemeMPLDeriveChildSkUnhardened({
    required Uint8List privateKeyBytes,
    required int index,
  });
  bool augSchemeMPLVerify({
    required Uint8List privateKeyBytes,
    required Uint8List messageBytes,
    required Uint8List signatureBytes,
  });

  int g1ElementGetFingerprint({
    required Uint8List g1ElementBytes,
  });
}
