import '../../chiatk_bls_signature.dart';

class DeriveKeys {
  DeriveKeys._();
  static PrivateKey _derivePath(PrivateKey sk, List<int> paths) {
    final startDate = DateTime.now();

    PrivateKey workingSK = sk;
    for (var path in paths) {
      workingSK = (AugSchemeMPL.deriveChildSk(
        privateKey: workingSK,
        index: path,
      ));
    }
    final endDate = DateTime.now();
    print('DerivePath: ${endDate.difference(startDate).inMilliseconds}');
    return workingSK;
  }

  static PrivateKey masterSkToFarmerSk(PrivateKey master) {
    return _derivePath(master, [12381, 8444, 0, 0]);
  }

  static PrivateKey masterSkToPoolSk(PrivateKey master) {
    return _derivePath(master, [12381, 8444, 1, 0]);
  }

  static PrivateKey masterSkToWalletSk(PrivateKey master, int index) {
    return _derivePath(master, [12381, 8444, 2, index]);
  }

  static PrivateKey rootWalletSkToWalletSk(PrivateKey rootSk, int index) {
    return _derivePath(rootSk, [index]);
  }

  static PrivateKey masterSkToRootWalletSk(PrivateKey master) {
    return _derivePath(master, [12381, 8444, 2]);
  }

  static PrivateKey masterSkToLocalSk(PrivateKey master) {
    return _derivePath(master, [12381, 8444, 3, 0]);
  }

  static PrivateKey masterSkToBackupSk(PrivateKey master) {
    return _derivePath(master, [12381, 8444, 4, 0]);
  }

  /// This key controls a singleton on the blockchain, allowing for dynamic pooling (changing pools)
  static PrivateKey masterSkToSingletonPwnerSk(
      PrivateKey master, int walletId) {
    return _derivePath(master, [12381, 8444, 5, walletId]);
  }

  /// This key controls a singleton on the blockchain, allowing for dynamic pooling (changing pools)
  static PrivateKey masteSkToPoolingAuthenticationSk(
      {required PrivateKey master, required int walletId, required int index}) {
    assert(index < 10000);
    assert(walletId < 10000);
    return _derivePath(master, [12381, 8444, 6, walletId * 10000 + index]);
  }

  static PrivateKey? finOwnerSk(
      {required List<PrivateKey> allSks, required G1Element ownerPk}) {
    for (var walletId = 0; walletId < 50; walletId++) {
      for (var sk in allSks) {
        final authSk = masterSkToSingletonPwnerSk(sk, walletId);
        final authSkG1 = authSk.getG1Element();
        if (authSkG1 == ownerPk) {
          return authSk;
        }
      }
    }
    return null;
  }

  static PrivateKey? findAuthenticationSk(
      {required List<PrivateKey> allSks, required G1Element authenticationPk}) {
    // NOTE: might need to increase this if using a large number of wallets, or have switched authentication keys
    // many times.
    for (var authKeyIndex = 0; authKeyIndex < 20; authKeyIndex++) {
      for (var walletId = 0; walletId < 20; walletId++) {
        for (var sk in allSks) {
          final authSk = masteSkToPoolingAuthenticationSk(
              master: sk, walletId: walletId, index: authKeyIndex);
          final authSkG1 = authSk.getG1Element();
          if (authSkG1 == authenticationPk) {
            return authSk;
          }
        }
      }
    }
    return null;
  }
}
