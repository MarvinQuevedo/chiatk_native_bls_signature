#import "bls-signatures/src/bls.hpp"
#import "bls-signatures/src/elements.hpp"
#import "bls-signatures/src/hdkeys.hpp"
#import "bls-signatures/src/hkdf.hpp"
#import "bls-signatures/src/privatekey.hpp"
#import "bls-signatures/src/schemes.hpp"
#import "bls-signatures/src/test-utils.hpp"
#import "bls-signatures/src/util.hpp"

using namespace bls;

extern "C" __attribute__((visibility("default"))) __attribute__((used)) bool Bls_Init() {
    //zf_log_set_tag_prefix("ChiaTKBlsSignature");
    return BLS::Init();
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
AugSchemeMPL_KeyGen(uint8_t *seedBytes, size_t seedLen, uint64_t *resultLen) {

    try {
        Bytes seedVector{seedBytes, seedLen};
        PrivateKey key = AugSchemeMPL().KeyGen(seedVector);

        std::vector<uint8_t> resultBuffer = key.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
PrivateKey_GetG1Element(uint8_t *privateKeyBytes, size_t privatekeyLen, uint64_t *resultLen) {

    try {

        Bytes privateKeyVector{privateKeyBytes, privatekeyLen};
        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        G1Element pk = sk.GetG1Element();

        std::vector<uint8_t> resultBuffer = pk.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}
extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
PrivateKey_GetG2Element(uint8_t *privateKeyBytes, size_t privatekeyLen, uint64_t *resultLen) {

    try {
        Bytes privateKeyVector{privateKeyBytes, privatekeyLen};
        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        G2Element g2Element = sk.GetG2Element();

        std::vector<uint8_t> resultBuffer = g2Element.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
AugSchemeMPL_Sign(uint8_t *privateKeyBytes, size_t privatekeyLen,
                  uint64_t *resultLen,
                  uint8_t *messageBytes, size_t messageBytesLen) {

    try {
        Bytes privateKeyVector{privateKeyBytes, privatekeyLen};
        Bytes messageVector{messageBytes, messageBytesLen};

        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        G2Element g1Element = AugSchemeMPL().Sign(sk, messageVector);

        std::vector<uint8_t> resultBuffer = g1Element.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}
extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
AugSchemeMPL_DeriveChildSk(uint8_t *privateKeyBytes, size_t privatekeyLen,
                  uint64_t *resultLen, uint32_t index) {

    try {
        Bytes privateKeyVector{privateKeyBytes, privatekeyLen};


        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        PrivateKey childKey = AugSchemeMPL().DeriveChildSk(sk, index);

        std::vector<uint8_t> resultBuffer = childKey.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
AugSchemeMPL_DeriveChildSkUnhardened(uint8_t *privateKeyBytes, size_t privatekeyLen,
                  uint64_t *resultLen, uint32_t index) {

    try {
        Bytes privateKeyVector{privateKeyBytes, privatekeyLen};


        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        PrivateKey childKey = AugSchemeMPL().DeriveChildSkUnhardened(sk, index);

        std::vector<uint8_t> resultBuffer = childKey.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t *
AugSchemeMPL_DeriveChildPkUnhardened(uint8_t *g1Bytes, size_t privatekeyLen,
                                     uint64_t *resultLen, uint32_t index) {

    try {
        Bytes g1ElementVector{g1Bytes, privatekeyLen};


        G1Element pk = G1Element::FromBytes(g1ElementVector);
        G1Element childKey = AugSchemeMPL().DeriveChildPkUnhardened(pk, index);

        std::vector<uint8_t> resultBuffer = childKey.Serialize();

        BLS::CheckRelicErrors();

        resultLen[0] = resultBuffer.size();
        uint8_t *r = resultBuffer.data();
        return r;
    }
    catch (...) {
        resultLen[0] = 0;
        return {};
    }
}



extern "C" __attribute__((visibility("default"))) __attribute__((used))
bool
AugSchemeMPL_Verify(uint8_t *privateKeyBytes, size_t privatekeyLen,
                    uint8_t *messageBytes, size_t messageBytesLen,
                    uint8_t *signedBytes, size_t signedBytesLen) {
    try {

        std::vector<uint8_t> seedVector(privateKeyBytes, privateKeyBytes + privatekeyLen);
        std::vector<uint8_t> messageVector(messageBytes, messageBytes + messageBytesLen);
        std::vector<uint8_t> signedVector(signedBytes, signedBytes + signedBytesLen);

        PrivateKey sk = PrivateKey::FromByteVector(seedVector, false);
        G1Element pk = sk.GetG1Element();
        G2Element signature = G2Element::FromByteVector(signedVector);
        bool ok = AugSchemeMPL().Verify(pk, messageVector, signature);

        BLS::CheckRelicErrors();

        return ok;
    }
    catch (...) {

        return false;
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint32_t
G1Element_GetFingerprint(uint8_t *g1Bytes, size_t privatekeyLen) {

    try {
        Bytes g1ElementVector{g1Bytes, privatekeyLen};

        G1Element pk = G1Element::FromBytes(g1ElementVector);
        uint32_t fingerprint =  pk.GetFingerprint();

        BLS::CheckRelicErrors();

        return fingerprint;
    }
    catch (...) {

        return 0;
    }
}



extern "C" __attribute__((visibility("default"))) __attribute__((used))
size_t
PrivateKey_Private_key_size() {
    return PrivateKey::PRIVATE_KEY_SIZE;
};

extern "C" __attribute__((visibility("default"))) __attribute__((used))
bool
Bls_CheckRelicErrors() {
    try {
        BLS::CheckRelicErrors();
        return true;
    }
    catch (...) {
        return false;
    }
};
