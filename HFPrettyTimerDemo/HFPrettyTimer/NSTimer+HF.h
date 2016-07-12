//
//  NSTimer+HF.h
//  helfyAppDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HF)

#ifndef HF_TIMER_USE_HOOK_MODE

typedef NS_ENUM(NSInteger,HFTimerStrategy) {
    HFTimerStrategyNone             = 1,       //NSTimer
    HFTimerStrategyWeakenTarget     = 1 << 2,  //不持有target
    HFTimerStrategyAutoInvalidate   = 1 << 3,  //自动invalidate(当target释放时),此时将会默认不持有target
};

+ (NSTimer *_Nonnull)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *_Nonnull)invocation repeats:(BOOL)yesOrNo prettyStrategy:(HFTimerStrategy)prettyStrategy;

+ (NSTimer *_Nonnull)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation * _Nonnull)invocation repeats:(BOOL)yesOrNo prettyStrategy:(HFTimerStrategy)prettyStrategy;

+ (NSTimer *_Nonnull)timerWithTimeInterval:(NSTimeInterval)ti target:(id _Nonnull)aTarget selector:(SEL _Nonnull)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyStrategy:(HFTimerStrategy)prettyStrategy;

+ (NSTimer *_Nonnull)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id _Nonnull)aTarget selector:(SEL _Nonnull)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyStrategy:(HFTimerStrategy)prettyStrategy;

#endif



@end
