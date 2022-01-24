import 'dart:ffi';
import "dart:ffi" as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi2;
import 'dart:typed_data';

import 'log.dart';

Uint8List convertToUint8List(
    {required Pointer<Uint8> value, required int size}) {
  Uint8List resultBytes = Uint8List(size);
  for (int i = 0; i < size; i++) {
    resultBytes[i] = value[i];
  }

  return resultBytes;
}

//// Extract Uit8List of Pointer
Pointer<Uint8> convertUint8ListToPointer(Uint8List bytes) {
  final pointer = ffi2.calloc<ffi.Uint8>(bytes.length);
  for (int i = 0; i < bytes.length; i++) {
    pointer[i] = bytes[i];
  }

  return pointer;
}

void deletePointerUint8({required Pointer<Uint8> value, required int size}) {
  /*  if (Platform.isAndroid) {
    for (int i = 0; i < size; i++) {
      value[i] = 0;
    }
    ffi2.Arena().free(value);
  } */
}

void deletePointerUint64({required Pointer<Uint64> value, required int size}) {
  /*  if (Platform.isAndroid) {
    for (int i = 0; i < size; i++) {
      value[i] = 0;
    }
    ffi2.Arena().free(value);
  } */
}

Pointer<Uint64> createSizePointer({int size = 1}) {
  return ffi2.calloc<ffi.Uint64>(size);
}

void printPointerUint8({required Pointer<Uint8> value, required int size}) {
  Log.print(convertToUint8List(size: size, value: value));
}
