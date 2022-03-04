import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:crypto/crypto.dart';
import "package:unorm_dart/unorm_dart.dart" as unorm;
import "package:hex/hex.dart";
import '../../chiatk_bls_signature.dart';

class KeyChain {
  /*
  mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        passphrase = "TREZOR"
  */
  static Uint8List mnemonicToSeed(String mnemonic, String passphrase) {
    String salt = "mnemonic" + passphrase;
    salt = normaliceNfkd(salt);
    final saltBytes = utf8.encode(salt);
    final mnemonicNormalized = normaliceNfkd(mnemonic);
    final nmonicBytes = utf8.encode(mnemonicNormalized);
    var hmacSha256 = Hmac(sha256, saltBytes); // HMAC-SHA256
    var digest = hmacSha256.convert(nmonicBytes);
    return Uint8List.fromList(digest.bytes);
  }

  static Future<String> bytesToMnemonic(Uint8List bytes) async {
    // if the bytes length is other, throw exception
    if (!([16, 20, 24, 28, 32].contains(bytes.length))) {
      throw Exception(
          "Data length should be one of the following: [16, 20, 24, 28, 32], but it is ${bytes.length}.");
    }
    final wordList = await mnmonicWords();
    final cs = bytes.length ~/ 4;
    final checksum = stdHash(bytes)[cs];

    final bitArray = Uint8List.fromList(bytes + [checksum]);
    var mnemonics = <String>[];

    assert((bitArray.length % 11) == 0, "(bitArray.length % 11) == 0");
    final length = bitArray.length ~/ 11;
    for (var i = 0; i < length; i++) {
      final start = i * 11;
      final end = start + 11;
      final bits = bitArray.sublist(start, end);
      final mWordPosition = bits.buffer.asUint8List().first;

      final mWord = wordList[mWordPosition];
      mnemonics.add(mWord);
    }
    final result = mnemonics.join(" ");
    Log.print(result);
    return result;
  }

  /// Return a random byte string containing [length] bytes.
  /// If [length] is ``None`` or not supplied, a reasonable
  /// default is used.
  static Uint8List tokenBytes({int length = 32}) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return Uint8List.fromList(values);
  }

  static Future<String> generateMnemonic() async {
    final mnemonicBytes = tokenBytes(length: 32);
    final mnemonic = await bytesToMnemonic(mnemonicBytes);
    return mnemonic;
  }
}

String toUf8(String value) {
  return utf8.decode(utf8.encode(value));
}

String bytestoHex(Uint8List bytes) {
  return "0x${HEX.encode(bytes)}";
}

Uint8List strToBytes(String value) {
  return Uint8List.fromList(utf8.encode(value));
}

String normaliceNfkd(String value) => toUf8(unorm.nfkd(value));
