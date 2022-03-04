import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/src/wrapper/generic_key.dart';

class G2Element extends GenericKey {
  G2Element(Uint8List? keyBytes) : super(keyBytes);
}
