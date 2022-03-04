import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/chiatk_bls_signature.dart';

class JacobianPoint extends G1Element {
  JacobianPoint(Uint8List? keyBytes) : super(keyBytes);
}
