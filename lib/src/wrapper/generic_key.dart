import 'dart:typed_data';

import 'package:chiatk_native_bls_signature/src/wallet/keychain.dart';

import '../../chiatk_bls_signature.dart';

abstract class GenericKey {
  /// bytes
  final Uint8List? _keyBytes;
  final bool obscureStringsPrints;

  const GenericKey(this._keyBytes, {this.obscureStringsPrints = false});

  /// Get bytes of PrivateKey
  Uint8List? serialize() => _keyBytes;
  Uint8List? get keyBytes => _keyBytes;

  /// Check is keyBytesis not null and the bytes not are only zeros
  bool isValid() {
    if (_keyBytes != null) {
      return !_onlyZeros();
    }
    return false;
  }

  bool _onlyZeros() {
    if (_keyBytes == null) return true;
    for (var i = 0; i < _keyBytes!.length; i++) {
      if (_keyBytes![i] != 0) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  bool? get _stringify => !obscureStringsPrints;

  @override
  String toString() {
    if (!(_stringify!)) {
      return "$runtimeType (****_obscure_****)";
    }

    return "$runtimeType (${_keyBytes?.length} length)(${toHex()})";
  }

  /// Removes all objects from the byte list; the length of the list becomes zero.
  void delete() {
    if (isValid()) {
      for (var i = 0; i < _keyBytes!.length; i++) {
        _keyBytes![i] = 0;
      }
    }
  }

  String toHex() {
    return bytestoHex(_keyBytes!);
  }

  Uint8List toBytes() => keyBytes!;

  @override
  int get hashCode => toHex().hashCode + runtimeType.hashCode;
}
