import 'dart:typed_data';

import 'package:crypto/crypto.dart';

Uint8List stdHash(Uint8List data) {
  return Uint8List.fromList(sha256.convert(data).bytes);
}

/** def std_hash(b) -> bytes32:
    """
    The standard hash used in many places.
    """
    return bytes32(blspy.Util.hash256(bytes(b)))*/