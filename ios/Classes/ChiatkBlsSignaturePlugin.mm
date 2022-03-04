#import "ChiatkBlsSignaturePlugin.h"
#import "helper.cpp"
 

@implementation ChiatkBlsSignaturePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"chiatk_bls_signature"
            binaryMessenger:[registrar messenger]];
  ChiatkBlsSignaturePlugin* instance = [[ChiatkBlsSignaturePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
