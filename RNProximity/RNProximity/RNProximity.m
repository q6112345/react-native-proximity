//
//  RNProximity.m
//
//  Created by William Bout
//

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RNProximity.h"
#import <AVFoundation/AVFoundation.h>

@implementation RNProximity

@synthesize bridge = _bridge;

- (instancetype)init
{
    if ((self = [super init])) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    BOOL proximityState = [[UIDevice currentDevice] proximityState];
    [self deviceIsCloseToUser:proximityState];
    [_bridge.eventDispatcher sendDeviceEventWithName:@"proximityStateDidChange"
                                                body:@{@"proximity": @(proximityState)}];
}


- (void)deviceIsCloseToUser:(BOOL)isCloseToUser {
    if (isCloseToUser) {
        //Switch to receiver
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else {
        //Switch to speaker
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }

}


RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(proximityEnabled:(BOOL)enabled) {
  [[UIDevice currentDevice] setProximityMonitoringEnabled:enabled];
}

@end
