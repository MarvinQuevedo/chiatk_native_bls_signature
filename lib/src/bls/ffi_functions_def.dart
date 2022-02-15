import 'dart:ffi';

// Init functions
typedef BlsInitFunction = Bool Function();
typedef BlsInitFunctionDart = bool Function();

typedef PrivateKeyFromSeedFunction = Pointer<Uint8> Function(
  Pointer<Uint8> seedBytes,
  Int32 seedLength,
  Pointer<Uint64> resultSizePointer,
);

typedef PrivateKeyFromSeedFunctionDart = Pointer<Uint8> Function(
  Pointer<Uint8> seedBytes,
  int seedLength,
  Pointer<Uint64> resultSizePointer,
);

typedef AugSchemeMPLSignFunction = Pointer<Uint8> Function(
  Pointer<Uint8> pkBytes,
  Int32 pkBytesLength,
  Pointer<Uint64> resultSizePointer,
  Pointer<Uint8> messageBytes,
  Int32 messageBytesLength,
);
typedef AugSchemeMPLSignFunctionDart = Pointer<Uint8> Function(
  Pointer<Uint8> pkBytes,
  int pkBytesLength,
  Pointer<Uint64> resultSizePointer,
  Pointer<Uint8> messageBytes,
  int messageBytesLength,
);

typedef AugSchemeMPLVerifyFunction = Bool Function(
  Pointer<Uint8> pkBytes,
  Int32 pkBytesLength,
  Pointer<Uint8> messageBytes,
  Int32 messageBytesLength,
  Pointer<Uint8> signatureBytes,
  Int32 signatureBytesLength,
);

typedef AugSchemeMPLVerifyFunctionDart = bool Function(
  Pointer<Uint8> seedBytes,
  int seedLength,
  Pointer<Uint8> messageBytes,
  int messageBytesLength,
  Pointer<Uint8> signatureBytes,
  int signatureBytesLength,
);

typedef AugSchemeMPLDeriveChildSkFunction = Pointer<Uint8> Function(
  Pointer<Uint8> pkBytes,
  Int32 pkBytesLength,
  Pointer<Uint64> resultSizePointer,
  Uint32 index,
);
typedef AugSchemeMPLDeriveChildSkFunctionDart = Pointer<Uint8> Function(
  Pointer<Uint8> pkBytes,
  int pkBytesLength,
  Pointer<Uint64> resultSizePointer,
  int index,
);

typedef G1ElementGetFingerprintFunction = Int32 Function(
    Pointer<Uint8> pkBytes, Int32 pkBytesLength);
typedef G1ElementGetFingerprintFunctionDart = int Function(
  Pointer<Uint8> pkBytes,
  int pkBytesLength,
);
