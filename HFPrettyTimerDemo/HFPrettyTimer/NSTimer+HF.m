//
//  NSTimer+HF.m
//  helfyAppDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "NSTimer+HF.h"
#import <objc/runtime.h>
#import "HFDeallocDetector.h"
#import "HFWeakensTarget.h"

@implementation NSTimer (HF)

#ifndef HF_TIMER_USE_HOOK_MODE
#pragma mark -- 分类模式。 缺点在于使用方法的改变, 
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo prettyType:(HFTimerStrategyType)prettyType {
   
    
    HFWeakensTarget *weakensTarget = nil;
    id originTarget = invocation.target;
    BOOL needDetector = NO;
    BOOL needWeakens = NO;
    
    switch (prettyType) {
        case HFTimerStrategyWeakenTarget: {
            needWeakens = YES;
        }
            break;
        case HFTimerStrategyAutoInvalidate: {
            needDetector = YES;
        }
            break;
        case HFTimerStrategyBoth: {
            needDetector = YES;
            needWeakens = YES;
        }
            break;
        default:
            break;
    }
    
    if(needWeakens) {
        weakensTarget = [HFWeakensTarget weakensTarget:invocation.target];
        invocation.target = weakensTarget;
    }
    NSTimer *timer = [self timerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    
    if(needDetector) {
        __weak typeof(timer) weakTimer = timer;
       [HFDeallocDetector detectorForTarget:originTarget targetDealloc:^(void) {
            [weakTimer invalidate];
        }];
    }
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo prettyType:(HFTimerStrategyType)prettyType {
    
    HFWeakensTarget *weakensTarget = nil;
    id originTarget = invocation.target;
    
    BOOL needDetector = NO;
    BOOL needWeakens = NO;
    
    switch (prettyType) {
        case HFTimerStrategyWeakenTarget: {
            needWeakens = YES;
        }
            break;
        case HFTimerStrategyAutoInvalidate: {
            needDetector = YES;
        }
            break;
        case HFTimerStrategyBoth: {
            needDetector = YES;
            needWeakens = YES;
        }
            break;
        default:
            break;
    }
    
    if(needWeakens) {
        weakensTarget =  [HFWeakensTarget weakensTarget:invocation.target];
        invocation.target = weakensTarget;
    }
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    if(needDetector) {
        __weak typeof(timer) weakTimer = timer;
         [HFDeallocDetector detectorForTarget:originTarget targetDealloc:^(void) {
            [weakTimer invalidate];
        }];
    }
    return timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyType:(HFTimerStrategyType)prettyType {
    
    BOOL needDetector = NO;
    BOOL needWeakens = NO;
    id originTarget = aTarget;
    switch (prettyType) {
        case HFTimerStrategyWeakenTarget: {
            needWeakens = YES;
        }
            break;
        case HFTimerStrategyAutoInvalidate: {
            needDetector = YES;
        }
            break;
        case HFTimerStrategyBoth: {
            needDetector = YES;
            needWeakens = YES;
        }
            break;
        default:
            break;
    }
    if(needWeakens) {
        aTarget = [HFWeakensTarget weakensTarget:aTarget];
    
    }
    NSTimer *timer = [self timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    
    if(needDetector) {
        __weak typeof(timer) weakTimer = timer;
        [HFDeallocDetector detectorForTarget:originTarget targetDealloc:^(void) {
            [weakTimer invalidate];
        }];
    }
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyType:(HFTimerStrategyType)prettyType {
    
    BOOL needDetector = NO;
    BOOL needWeakens = NO;
    id originTarget = aTarget;
    
    switch (prettyType) {
        case HFTimerStrategyWeakenTarget: {
            needWeakens = YES;
        }
            break;
        case HFTimerStrategyAutoInvalidate: {
            needDetector = YES;
        }
            break;
        case HFTimerStrategyBoth: {
            needDetector = YES;
            needWeakens = YES;
        }
            break;
        default:
            break;
    }
    
    if(needWeakens) {
        aTarget = [HFWeakensTarget weakensTarget:aTarget];
    }
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:YES];
    
    if(needDetector) {
        __weak typeof(timer) weakTimer = timer;
        [HFDeallocDetector detectorForTarget:originTarget targetDealloc:^(void) {
            [weakTimer invalidate];
        }];
    }
    return timer;
}

#else
#pragma mark --- hook 模式。。缺点在于影响全局。不能控制是否使用改模式。而且不清楚是否会对系统造成影响，优点在于不用去挨个修改
+ (void)load {
    
    SEL selectors[] = {
        @selector(timerWithTimeInterval:target:selector:userInfo:repeats:),
        @selector(timerWithTimeInterval:invocation:repeats:),
        @selector(scheduledTimerWithTimeInterval:invocation:repeats:),
        @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"hf_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getClassMethod(self, originalSelector);
        Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (NSTimer *)hf_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    
    HFWeakensTarget *weakensTarget =  [HFWeakensTarget weakensTarget:aTarget];
    NSTimer *timer = [self hf_timerWithTimeInterval:ti target:weakensTarget selector:aSelector userInfo:userInfo repeats:aSelector];
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:aTarget targetDealloc:^(void) {
        [weakTimer invalidate];
    }];
    return timer;
}

+ (NSTimer *)hf_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    
    HFWeakensTarget *weakensTarget =  [HFWeakensTarget weakensTarget:aTarget];
    
    NSTimer *timer = [self hf_scheduledTimerWithTimeInterval:ti target:weakensTarget selector:aSelector userInfo:userInfo repeats:aSelector];
    
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:aTarget targetDealloc:^(void) {
        [weakTimer invalidate];
    }];
    return timer;
}
#pragma  mark NSInvocation 模式
+ (NSTimer *)hf_timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
  
    id originTarget = invocation.target;
    invocation.target = [HFWeakensTarget weakensTarget:invocation.target];;
    
    NSTimer *timer = [self hf_timerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
  
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:originTarget targetDealloc:^(void) {
        [weakTimer invalidate];
    }];
    return timer;
}

+ (NSTimer *)hf_scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    
    id originTarget = invocation.target;
    invocation.target = [HFWeakensTarget weakensTarget:invocation.target];;
    
    NSTimer *timer = [self hf_scheduledTimerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:originTarget targetDealloc:^(void) {
        [weakTimer invalidate];
    }];
    return timer;
}

#endif
@end
