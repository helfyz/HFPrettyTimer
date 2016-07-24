//
//  NSTimer+HF.m
//  helfyAppDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "NSTimer+HFPretty.h"
#import <objc/runtime.h>
#import "HFDeallocDetector.h"
#import "HFWeakensTarget.h"

@implementation NSTimer (HFPretty)

#pragma mark - life cycle

+ (void)load {
    NSMutableArray <NSString *> *selectors = @[].mutableCopy;
    [selectors addObject:@"timerWithTimeInterval:target:selector:userInfo:repeats:"];
    [selectors addObject:@"timerWithTimeInterval:invocation:repeats:"];
    [selectors addObject:@"scheduledTimerWithTimeInterval:invocation:repeats:"];
    [selectors addObject:@"scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"];
    for (NSString *selector in selectors) {
        SEL originalSelector = NSSelectorFromString(selector);
        SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"hf_%@",selector]);
        Method originalMethod = class_getClassMethod(self, originalSelector);
        Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - swizzled Method

+ (NSTimer *)hf_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    if (![aTarget shouldWeaken]) {
        return [self hf_timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    
    HFWeakensTarget *weakensTarget =  [HFWeakensTarget weakensTarget:aTarget];
    NSTimer *timer = [self hf_timerWithTimeInterval:ti target:weakensTarget selector:aSelector userInfo:userInfo repeats:aSelector];
    
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:aTarget deallocDetectedHandler:^{
        [weakTimer invalidate];
    }];
    return timer;
}

+ (NSTimer *)hf_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    if (![aTarget shouldWeaken]) {
        return [self hf_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    
    __block HFWeakensTarget *weakensTarget =  [HFWeakensTarget weakensTarget:aTarget];
    
    NSTimer *timer = [self hf_scheduledTimerWithTimeInterval:ti target:weakensTarget selector:aSelector userInfo:userInfo repeats:aSelector];
    
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:aTarget deallocDetectedHandler:^{
        [weakTimer invalidate];
    }];
    return timer;
}

+ (NSTimer *)hf_timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    id originTarget = invocation.target;
    if (![originTarget shouldWeaken]) {
        return [self hf_timerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    }

    invocation.target = [HFWeakensTarget weakensTarget:invocation.target];;
    NSTimer *timer = [self hf_timerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
  
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:originTarget deallocDetectedHandler:^{
        
        [weakTimer invalidate];
    }];
    return timer;
}

+ (NSTimer *)hf_scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    id originTarget = invocation.target;
    if (![originTarget shouldWeaken]) {
        return [self hf_scheduledTimerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    }
    
    invocation.target = [HFWeakensTarget weakensTarget:invocation.target];;
    NSTimer *timer = [self hf_scheduledTimerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    
    __weak typeof(timer) weakTimer = timer;
    [HFDeallocDetector detectorForTarget:originTarget deallocDetectedHandler:^{
        [weakTimer invalidate];
    }];
    return timer;
}

@end
