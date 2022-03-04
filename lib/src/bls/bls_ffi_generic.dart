import 'package:chiatk_native_bls_signature/src/utils/buffers_utils.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/relic_exception.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../../chiatk_bls_signature.dart';
import 'bls_platform.dart';

import 'dart:ffi';
import "dart:ffi" as ffi;
import 'ffi_functions_def.dart';

class BlsFfiGeneric extends BlsPlatform {
  @protected
  DynamicLibrary? nativeLib;
  @protected
  DynamicLibrary get lib => nativeLib!;

  @override
  void init() {
    nativeLib = DynamicLibrary.open('libchiatkbls.so');

    final fn =
        lib.lookupFunction<BlsInitFunction, BlsInitFunctionDart>("Bls_Init");
    final result = fn.call();
    Log.print("FFI init $result");
  }

  @override
  PrivateKey? augSchemeMPLKeyGen(Uint8List seed) {
    Uint8List resultBytes = _genericSendBytesReceiveBytes(
        methodName: "AugSchemeMPL_KeyGen", seed: seed);

    // finally create the PrivateKey instance
    var privateKey = PrivateKey(resultBytes);
    return privateKey;
  }

  @override
  bool? test() {
    return true;
  }

  @override
  G1Element? privateKeyGetG1Element(Uint8List privateKeyBytes) {
    Uint8List resultBytes = _genericSendBytesReceiveBytes(
        methodName: "PrivateKey_GetG1Element", seed: privateKeyBytes);

    // finally create the PrivateKey instance
    var privateKey = G1Element(resultBytes);
    return privateKey;
  }

  @override
  G2Element? privateKeyGetG2Element(Uint8List privateKeyBytes) {
    Uint8List resultBytes = _genericSendBytesReceiveBytes(
        methodName: "PrivateKey_GetG2Element", seed: privateKeyBytes);

    // finally create the PrivateKey instance
    var privateKey = G2Element(resultBytes);
    return privateKey;
  }

  Uint8List _genericSendBytesReceiveBytes({
    required Uint8List seed,
    required String methodName,
  }) {
    final fn = lib.lookupFunction<PrivateKeyFromSeedFunction,
        PrivateKeyFromSeedFunctionDart>(methodName);
    //Log.print("hex ${bytestoHex(seed)}");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(seed);
    //Log.print("seedPointer = ${seedPointer.address} ${seedPointer.value}");

    /// We need know the result size, the pointer allow know it
    final pointerResultSize = createSizePointer();
    // Call the native function
    final result = fn.call(seedPointer, seed.length, pointerResultSize);
    final resultSize = pointerResultSize[0];
    // Extract the bytes of the Pointer

    if (resultSize == 0) {
      deletePointerUint8(size: resultSize, value: result);
      deletePointerUint64(size: 1, value: pointerResultSize);
      deletePointerUint8(size: seed.length, value: seedPointer);
      throw RelicException();
    }

    Uint8List resultBytes = convertToUint8List(
      value: result,
      size: resultSize,
    );

    // Release and delete the pointers
    deletePointerUint8(size: resultSize, value: result);
    deletePointerUint64(size: 1, value: pointerResultSize);
    deletePointerUint8(size: seed.length, value: seedPointer);

    // finally create the PrivateKey instance

    return resultBytes;
  }

  @override
  G2Element? augSchemeMPLSign(
      {required Uint8List privateKeyBytes, required Uint8List messageBytes}) {
    final fn = lib.lookupFunction<AugSchemeMPLSignFunction,
        AugSchemeMPLSignFunctionDart>("AugSchemeMPL_Sign");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(privateKeyBytes);
    final messagePointer = convertUint8ListToPointer(messageBytes);

    /// We need know the result size, the pointer allow know it
    final pointerResultSize = createSizePointer();
    // Call the native function
    final result = fn.call(
      seedPointer,
      privateKeyBytes.length,
      pointerResultSize,
      messagePointer,
      messageBytes.length,
    );
    final resultSize = pointerResultSize[0];
    // Extract the bytes of the Pointer

    if (resultSize == 0) {
      deletePointerUint8(size: resultSize, value: result);
      deletePointerUint64(size: 1, value: pointerResultSize);

      deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);
      deletePointerUint8(size: messageBytes.length, value: messagePointer);
      throw RelicException();
    }

    Uint8List resultBytes = convertToUint8List(
      value: result,
      size: resultSize,
    );

    // Release and delete the pointers
    deletePointerUint8(size: resultSize, value: result);
    deletePointerUint64(size: 1, value: pointerResultSize);

    deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);
    deletePointerUint8(size: messageBytes.length, value: messagePointer);

    // finally create the PrivateKey instance

    return G2Element(resultBytes);
  }

  @override
  bool augSchemeMPLVerify(
      {required Uint8List privateKeyBytes,
      required Uint8List messageBytes,
      required Uint8List signatureBytes}) {
    final fn = lib.lookupFunction<AugSchemeMPLVerifyFunction,
        AugSchemeMPLVerifyFunctionDart>("AugSchemeMPL_Verify");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(privateKeyBytes);
    final messagePointer = convertUint8ListToPointer(messageBytes);
    final signaturePointer = convertUint8ListToPointer(signatureBytes);

    // Call the native function
    final result = fn.call(seedPointer, privateKeyBytes.length, messagePointer,
        messageBytes.length, signaturePointer, signatureBytes.length);

    // Release and delete the pointers
    deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);
    deletePointerUint8(size: messageBytes.length, value: messagePointer);
    deletePointerUint8(size: signatureBytes.length, value: signaturePointer);

    // finally create the PrivateKey instance

    return result;
  }

  @override
  PrivateKey? augSchemeMPLDeriveChildSk(
      {required Uint8List privateKeyBytes, required int index}) {
    final fn = lib.lookupFunction<AugSchemeMPLDeriveChildSkFunction,
        AugSchemeMPLDeriveChildSkFunctionDart>("AugSchemeMPL_DeriveChildSk");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(privateKeyBytes);

    /// We need know the result size, the pointer allow know it
    final pointerResultSize = createSizePointer();
    // Call the native function
    final result =
        fn.call(seedPointer, privateKeyBytes.length, pointerResultSize, index);
    final resultSize = pointerResultSize[0];
    // Extract the bytes of the Pointer

    if (resultSize == 0) {
      deletePointerUint8(size: resultSize, value: result);
      deletePointerUint64(size: 1, value: pointerResultSize);

      deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);

      throw RelicException();
    }

    Uint8List resultBytes = convertToUint8List(
      value: result,
      size: resultSize,
    );

    // Release and delete the pointers
    deletePointerUint8(size: resultSize, value: result);
    deletePointerUint64(size: 1, value: pointerResultSize);

    deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);

    // finally create the PrivateKey instance

    return PrivateKey(resultBytes);
  }

  @override
  PrivateKey? augSchemeMPLDeriveChildSkUnhardened(
      {required Uint8List privateKeyBytes, required int index}) {
    final fn = lib.lookupFunction<AugSchemeMPLDeriveChildSkFunction,
            AugSchemeMPLDeriveChildSkFunctionDart>(
        "AugSchemeMPL_DeriveChildSkUnhardened");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(privateKeyBytes);

    /// We need know the result size, the pointer allow know it
    final pointerResultSize = createSizePointer();
    // Call the native function
    final result =
        fn.call(seedPointer, privateKeyBytes.length, pointerResultSize, index);
    final resultSize = pointerResultSize[0];
    // Extract the bytes of the Pointer

    if (resultSize == 0) {
      deletePointerUint8(size: resultSize, value: result);
      deletePointerUint64(size: 1, value: pointerResultSize);

      deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);

      throw RelicException();
    }

    Uint8List resultBytes = convertToUint8List(
      value: result,
      size: resultSize,
    );

    // Release and delete the pointers
    deletePointerUint8(size: resultSize, value: result);
    deletePointerUint64(size: 1, value: pointerResultSize);

    deletePointerUint8(size: privateKeyBytes.length, value: seedPointer);

    // finally create the PrivateKey instance

    return PrivateKey(resultBytes);
  }

  @override
  G1Element? augSchemeMPLDeriveChildPkUnhardened(
      {required Uint8List g1ElementBytes, required int index}) {
    final fn = lib.lookupFunction<AugSchemeMPLDeriveChildSkFunction,
            AugSchemeMPLDeriveChildSkFunctionDart>(
        "AugSchemeMPL_DeriveChildPkUnhardened");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(g1ElementBytes);

    /// We need know the result size, the pointer allow know it
    final pointerResultSize = createSizePointer();
    // Call the native function
    final result =
        fn.call(seedPointer, g1ElementBytes.length, pointerResultSize, index);
    final resultSize = pointerResultSize[0];
    // Extract the bytes of the Pointer

    if (resultSize == 0) {
      deletePointerUint8(size: resultSize, value: result);
      deletePointerUint64(size: 1, value: pointerResultSize);
      deletePointerUint8(size: g1ElementBytes.length, value: seedPointer);

      throw RelicException();
    }

    Uint8List resultBytes = convertToUint8List(
      value: result,
      size: resultSize,
    );

    // Release and delete the pointers
    deletePointerUint8(size: resultSize, value: result);
    deletePointerUint64(size: 1, value: pointerResultSize);
    deletePointerUint8(size: g1ElementBytes.length, value: seedPointer);

    // finally create the PrivateKey instance

    return G1Element(resultBytes);
  }

  @override
  int g1ElementGetFingerprint({required Uint8List g1ElementBytes}) {
    final fn = lib.lookupFunction<G1ElementGetFingerprintFunction,
            G1ElementGetFingerprintFunctionDart>(
        "AugSchemeMPL_DeriveChildPkUnhardened");

    /// Create the pointer for pass to native
    final seedPointer = convertUint8ListToPointer(g1ElementBytes);

    // Call the native function
    final result = fn.call(seedPointer, g1ElementBytes.length);

    // Extract the bytes of the Pointer

    if (result == 0) {
      deletePointerUint8(size: g1ElementBytes.length, value: seedPointer);

      throw RelicException();
    }

    // Release and delete the pointers

    deletePointerUint8(size: g1ElementBytes.length, value: seedPointer);

    // finally create the PrivateKey instance

    return result;
  }
}
