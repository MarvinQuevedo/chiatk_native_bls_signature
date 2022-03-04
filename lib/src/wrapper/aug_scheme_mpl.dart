import 'dart:convert';
import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/src/native_channel.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/g1_elements.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/g2_elements.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/jacobian_point.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/private_key.dart';
import 'package:chiatk_native_bls_signature/src/wrapper/relic_exception.dart';

class AugSchemeMPL {
  AugSchemeMPL._();
  static PrivateKey? keyGen(Uint8List seed) {
    return ChiatkBlsSignatureNative.platform.augSchemeMPLKeyGen(seed);
  }

  static JacobianPoint sign(PrivateKey privateKey, Uint8List messageBytes) {
    var augSchemeMPLSign = ChiatkBlsSignatureNative.platform.augSchemeMPLSign(
      messageBytes: messageBytes,
      privateKeyBytes: privateKey.keyBytes!,
    )!;
    return JacobianPoint(augSchemeMPLSign.keyBytes);
  }

  static G2Element? signBytes(
      {required PrivateKey privateKey, required Uint8List messageBytes}) {
    return ChiatkBlsSignatureNative.platform.augSchemeMPLSign(
      messageBytes: messageBytes,
      privateKeyBytes: privateKey.keyBytes!,
    );
  }

  static PrivateKey deriveChildSk(
      {required PrivateKey privateKey, required int index}) {
    var counter = 0;
    do {
      try {
        return ChiatkBlsSignatureNative.platform.augSchemeMPLDeriveChildSk(
          index: index,
          privateKeyBytes: privateKey.keyBytes!,
        )!;
      } catch (e) {
        print(e);
        counter++;
      }
    } while (counter < 20);
    throw RelicException();
  }

  static PrivateKey? deriveChildSkUnhardened(
      {required PrivateKey privateKey, required int index}) {
    var counter = 0;
    do {
      try {
        return ChiatkBlsSignatureNative.platform
            .augSchemeMPLDeriveChildSkUnhardened(
          index: index,
          privateKeyBytes: privateKey.keyBytes!,
        );
      } catch (e) {
        print(e);
        counter++;
      }
    } while (counter < 20);
    throw RelicException();
  }

  static G1Element? deriveChildPkUnhardened(
      {required G1Element g1Element, required int index}) {
    var counter = 0;
    do {
      try {
        return ChiatkBlsSignatureNative.platform
            .augSchemeMPLDeriveChildPkUnhardened(
          index: index,
          g1ElementBytes: g1Element.keyBytes!,
        );
      } catch (e) {
        print(e);
        counter++;
      }
    } while (counter < 20);
    throw RelicException();
  }

  static bool verify(
      {required PrivateKey privateKey,
      required String message,
      required G2Element signature}) {
    return ChiatkBlsSignatureNative.platform.augSchemeMPLVerify(
        messageBytes: Uint8List.fromList(utf8.encode(message)),
        privateKeyBytes: privateKey.keyBytes!,
        signatureBytes: signature.keyBytes!);
  }
}
