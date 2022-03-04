import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:chiatk_native_bls_signature/chiatk_bls_signature.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChiatkBlsSignature.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String encripted = "";
  final msgTextController = TextEditingController(
      text:
          "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about");
  double number = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: msgTextController,
                  decoration: const InputDecoration(label: Text("Seed")),
                  maxLines: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      _test();
                    },
                    child: const Text("Probar")),
                ElevatedButton(
                    onPressed: () {
                      testGetPublicKey();
                    },
                    child: const Text("testGetPublicKey")),
                if (encripted.isNotEmpty)
                  Text("public key: $encripted $number"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _test() async {
    final seed = Uint8List.fromList([
      0,
      50,
      6,
      244,
      24,
      199,
      1,
      25,
      52,
      88,
      192,
      19,
      18,
      12,
      89,
      6,
      220,
      18,
      102,
      58,
      209,
      82,
      12,
      62,
      89,
      110,
      182,
      9,
      44,
      20,
      254,
      22
    ]);
    final privateKey = await AugSchemeMPL.keyGen(seed);
    Log.print(privateKey!.toHex());
  }

  void testGetPrivateKey() async {
    const mnemonic =
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about";
    const passphrase = "TREZOR";
    final seed = KeyChain.mnemonicToSeed(mnemonic, passphrase);
    /* const tv_master_int =
        "5399117110774477986698372024995405256382522670366369834617409486544348441851";
    const tv_child_int =
        "11812940737387919040225825939013910852517748782307378293770044673328955938106"; */
    final privateKey = await AugSchemeMPL.keyGen(seed);
    Log.print(privateKey!.toHex());
  }

  void testGetPublicKey() async {
    KeyChain.generateMnemonic();
    //number++;
    final mnemonic = msgTextController.text;
    const passphrase = "TREZOR";
    final seed = KeyChain.mnemonicToSeed(mnemonic, passphrase);
/*     final tv_master_int =
        "5399117110774477986698372024995405256382522670366369834617409486544348441851";
    final tv_child_int =
        "11812940737387919040225825939013910852517748782307378293770044673328955938106"; */
    final seedObj = Seed(seed);
    Log.print(seed);
    Log.print(seedObj.toHex());
    final masterSK = await AugSchemeMPL.keyGen(seed);
    Log.print("privateKey");
    Log.print(masterSK);

    final farmerSk = await DeriveKeys.masterSkToFarmerSk(masterSK!);
    final masterPk = await masterSK.getG1Element();
    Log.print("g1Element");
    Log.print(masterPk);
    final g2Element = await masterSK.getG2Element();
    Log.print("g2Element");
    Log.print(g2Element);
    const message = "Hola, este mensaje va a ser firmado";
    final signature =
        AugSchemeMPL.sign(masterSK, Uint8List.fromList(utf8.encode(message)));
    Log.print("signature");
    Log.print(signature);
    final signatureIsOk = AugSchemeMPL.verify(
        privateKey: masterSK,
        message: message,
        signature: signature.toG2Element());
    Log.print("is ok $signatureIsOk");
    try {
      final childKey =
          await AugSchemeMPL.deriveChildSk(privateKey: masterSK, index: 152);

      Log.print("childKey");
      Log.print(childKey!.toHex());
      PrivateKey? grandChild =
          await AugSchemeMPL.deriveChildSk(privateKey: childKey, index: 952);
      Log.print("grandChild");
      Log.print(grandChild!.toHex());

      PrivateKey? childU = await AugSchemeMPL.deriveChildSkUnhardened(
          privateKey: masterSK, index: 22);
      Log.print("childU");
      Log.print(childU!.toHex());

      PrivateKey? grandchildU = await AugSchemeMPL.deriveChildSkUnhardened(
          privateKey: childU, index: 22);
      Log.print("grandchildU");
      Log.print(grandchildU!.toHex());

      G1Element? masterPk = await masterSK.getG1Element();
      G1Element? childUPk = await AugSchemeMPL.deriveChildPkUnhardened(
          index: 22, g1Element: masterPk!);

      Log.print("childUPk");
      Log.print(childUPk);

      G1Element? grandchildUPk = await AugSchemeMPL.deriveChildPkUnhardened(
          index: 22, g1Element: childUPk!);
      Log.print("grandchildUPk");
      Log.print(grandchildUPk!.toHex());

      G1Element? grandchildUChild = await grandchildU.getG1Element();
      Log.print("grandchildUChild");
      Log.print(grandchildUChild!.toHex());
      if (grandchildUChild == grandchildUPk) {
        Log.print("Ok");
      } else {
        Log.print("FAILED");
      }
      Log.print("deleting key");
      grandchildUChild.delete();

      if (grandchildUChild.isValid()) {
        Log.print("No deleted");
      } else {
        Log.print("Deleted successfull");
      }
    } catch (e) {
      print(e);
    }
    /*final child23 = await publicKey?.publicChild(23);
    print("child");
    print(child23); */
  }
}
