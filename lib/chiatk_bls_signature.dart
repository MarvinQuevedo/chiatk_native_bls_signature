export 'src/wrapper/private_key.dart';
export 'src/wrapper/generic_key.dart';
export 'src/wrapper/aug_scheme_mpl.dart';
export 'src/wrapper/g1_elements.dart';
export 'src/wrapper/g2_elements.dart';
export 'src/wrapper/seed.dart';
export 'src/wrapper/jacobian_point.dart';

export 'src/wallet/coinbase.dart';
export 'src/wallet/derive_keys.dart';
export 'src/wallet/keychain.dart';
export 'src/wallet/mnmonic_words.dart';
export 'src/wallet/std_hash.dart';

export 'src/utils/log.dart';

import 'src/native_channel.dart';

/// Chia BLS implementation
class ChiatkBlsSignature {
  static bool _initialized = false;

  /// check is the BSL library was initialized
  static bool get initialized => _initialized;

  /// Initialize BLS library
  static Future<void> init() async {
    ChiatkBlsSignatureNative.platform.init();
    _initialized = true;
  }
}
