//
//  NSTimer+HF.h
//  helfyAppDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define HF_TIMER_USE_HOOK_MODE


@interface NSTimer (HF)

#ifndef HF_TIMER_USE_HOOK_MODE

typedef NS_ENUM(NSInteger,NSTimerPrettyType) {
    
    NSTimerPrettyTypeDetault = 0,       //不做任何释放或者weak target操作,即原生Timer
    NSTimerPrettyTypeWeakTarget,        //弱化target ，消除timer 与 持有者的循环引用
    NSTimerPrettyTypeAutoInvalidate,    //当timer的持有者释放时，timer 自动invalidate  ，注:当持有者和timer 循环引用的时候。是不会起作用的，不推荐使用
    NSTimerPrettyTypeBoth,              // 弱化 并 主动invalidate  ，WeakTarget & AutoInvalidate 只是为一些变态需求提供出来，
};

+ (NSTimer *_Nonnull)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *_Nonnull)invocation repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType;

+ (NSTimer *_Nonnull)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation * _Nonnull)invocation repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType;

+ (NSTimer *_Nonnull)timerWithTimeInterval:(NSTimeInterval)ti target:(id _Nonnull)aTarget selector:(SEL _Nonnull)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType;

+ (NSTimer *_Nonnull)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id _Nonnull)aTarget selector:(SEL _Nonnull)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType;
#endif



@end
