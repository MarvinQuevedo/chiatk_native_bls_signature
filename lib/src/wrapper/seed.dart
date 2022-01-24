import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/chiatk_bls_signature.dart';

class Seed extends GenericKey {
  Seed(Uint8List? keyBytes) : super(keyBytes);
}
