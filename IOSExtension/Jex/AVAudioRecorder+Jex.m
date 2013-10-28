//
//  AVAudioRecorder+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-10-9.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "AVAudioRecorder+Jex.h"

@implementation AVAudioRecorder (Jex)

+ (AVAudioRecorder *)recordToPath:(NSString *)fullPath withDelegate:(id<AVAudioRecorderDelegate>)dstDelegate {
    static NSMutableDictionary * recordSettings = nil;
    if (!recordSettings) {
        recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
        [recordSettings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithFloat:16000.0] forKey: AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
    }
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1
    if ([audioSession inputIsAvailable]) {
#else
    if ([audioSession isInputAvailable]) {
#endif
        AVAudioRecorder * recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:fullPath] settings:recordSettings error:nil];
        [recorder setDelegate:dstDelegate];
        [recorder setMeteringEnabled:YES];
        if ([recorder prepareToRecord]) {
            [recorder recordForDuration:VOICE_CHAT_TIME + 5];
        }
        return recorder;
    }
    return nil;
}

@end
