//
//  helper.cpp
//  chiatk_bls_signature
//
//  Created by Marvin Quevedo on 18/12/21.
//

#include "helper.hpp"
#include "zf_log.h"

//
//  BlsHelper.cpp
//  chiatk_bls_signature
//
//  Created by Marvin Quevedo on 16/12/21.
//

void printInfo(const char *const input){
    zf_log_set_output_level(ZF_LOG_INFO);
    ZF_LOGW("%s", input);
}
void printWarning(const char *const input){
    zf_log_set_output_level(ZF_LOG_WARN);
    ZF_LOGW("%s", input);
}
void printError(const char *const input){
    zf_log_set_output_level(ZF_LOG_ERROR);
    ZF_LOGW("%s", input);
}
 


extern "C" __attribute__((visibility("default"))) __attribute__((used))
bool Bls_Init(){
    zf_log_set_tag_prefix("ChiaTKBlsSignature");
    return BLS::Init();
}


extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t* AugSchemeMPL_KeyGen(uint8_t * seedBytes, size_t seedLen, uint64_t * resultLen){
    
    try {
        Bytes seedVector  { seedBytes,seedLen};
        PrivateKey key = AugSchemeMPL().KeyGen(seedVector);

        std::vector<uint8_t> resultBuffer =  key.Serialize( );
        
        BLS::CheckRelicErrors();
        
        resultLen[0] = resultBuffer.size();
        uint8_t* r =  resultBuffer.data();
        return r;
    } catch (...) {
        resultLen[0] = 0;
        return {};
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t* PrivateKey_GetG1Element(uint8_t * privateKeyBytes, size_t privatekeyLen, uint64_t * resultLen){
    
    try {
       
        Bytes privateKeyVector  { privateKeyBytes,privatekeyLen};
        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        G1Element pk = sk.GetG1Element();

        std::vector<uint8_t> resultBuffer =  pk.Serialize( );
        
        BLS::CheckRelicErrors();
        
        resultLen[0] = resultBuffer.size();
        uint8_t* r =  resultBuffer.data();
        return r;
    } catch (...) {
        resultLen[0] = 0;
        return {};
    }
    
}
extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t* PrivateKey_GetG2Element(uint8_t * privateKeyBytes, size_t privatekeyLen, uint64_t * resultLen){
    
    try {
        Bytes privateKeyVector  { privateKeyBytes,privatekeyLen};
        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        G2Element g2Element = sk.GetG2Element();

        std::vector<uint8_t> resultBuffer =  g2Element.Serialize( );
        
        BLS::CheckRelicErrors();
        
        resultLen[0] = resultBuffer.size();
        uint8_t* r =  resultBuffer.data();
        return r;
    } catch (...) {
        resultLen[0] = 0;
        return {};
    }
   
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t* AugSchemeMPL_Sign(uint8_t * privateKeyBytes, size_t privatekeyLen,
                           uint64_t * resultLen,
                           uint8_t * messageBytes, size_t messageBytesLen){
    
    try {
        Bytes privateKeyVector  { privateKeyBytes,privatekeyLen};
        Bytes messageVector  { messageBytes,messageBytesLen};
    

        PrivateKey sk = PrivateKey::FromBytes(privateKeyVector, false);
        G2Element g1Element = AugSchemeMPL().Sign(sk, messageVector);

        std::vector<uint8_t> resultBuffer =  g1Element.Serialize( );
        
        BLS::CheckRelicErrors();
        
        resultLen[0] = resultBuffer.size();
        uint8_t* r =  resultBuffer.data();
        return r;
    } catch (...) {
        resultLen[0] = 0;
        return {};
    }
   
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
bool AugSchemeMPL_Verify(uint8_t * privateKeyBytes, size_t privatekeyLen,
                             uint8_t * messageBytes, size_t messageBytesLen,
                             uint8_t * signedBytes, size_t signedBytesLen){
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
    } catch (...) {
        
        return false;
    }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
size_t PrivateKey_Private_key_size(){
    return PrivateKey::PRIVATE_KEY_SIZE;
};

extern "C" __attribute__((visibility("default"))) __attribute__((used))
bool Bls_CheckRelicErrors(){
    try {
        BLS::CheckRelicErrors();
        return true;
    } catch (...) {
        return false;
    }
};

