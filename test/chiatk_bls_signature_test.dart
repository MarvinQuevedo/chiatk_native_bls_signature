import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chiatk_native_bls_signature/chiatk_bls_signature.dart';

void main() async {
  const MethodChannel channel = MethodChannel('chiatk_bls_signature');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
  Log.print(KeyChain.tokenBytes());
  Log.print(await KeyChain.generateMnemonic());
  test('getPlatformVersion', () async {});
}
