import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/src/utils/endian.dart';

Uint8List int32ToBytes(int value) => Uint8List.fromList(
    encodeEndian(value, 8, endianType: EndianType.bigEndian));

int fromBytesToInt32(Uint8List bytes) {
  return Uint8List.fromList(bytes.reversed.toList()).buffer.asUint32List()[0];
}
