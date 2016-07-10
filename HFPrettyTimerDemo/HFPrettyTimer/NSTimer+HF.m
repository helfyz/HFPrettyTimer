//
//  NSTimer+HF.m
//  helfyAppDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "NSTimer+HF.h"
#import <objc/runtime.h>

@interface HFWatcher : NSObject
@property (nonatomic, weak) NSTimer *timer;
@end
@implementation HFWatcher


/**
 *  为target 创建一个观察对象
 *
 *  @param target target
 *
 *  @return 观察者
 */
+ (HFWatcher *)watcherForTarget:(id)target {
    HFWatcher *watcher = [[HFWatcher alloc] init];
    objc_setAssociatedObject(target, "hf_watcher",watcher, OBJC_ASSOCIATION_RETAIN);
    return watcher;
}

-(void)dealloc {
    NSLog(@"HFWatcher dealloc");
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end

@interface HFWeakTarget : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, weak) NSInvocation *invocation;

@end
@implementation HFWeakTarget

/**
 *  为target 创建一个 弱引用对象。避开循环引用
 *
 *  @param target target
 *
 *  @return 弱引用对象
 */
+ (HFWeakTarget *)weakTargetFor:(id)target {
    HFWeakTarget *otherTarget = [[HFWeakTarget alloc] init];
    otherTarget.target = target;
    return otherTarget;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

-(void)dealloc {
    NSLog(@"HFWeakTarget dealloc");
}
@end


@implementation NSTimer (HF)

#ifndef USE_HOOK_MODE
#pragma mark -- 分类模式。 缺点在于使用方法的改变, 
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType {
   
    
    HFWatcher *watcher = nil;
    HFWeakTarget *otherTarget = nil;
    switch (prettyType) {
        case NSTimerPrettyTypeWeakTarget: {
            otherTarget =  [HFWeakTarget weakTargetFor:invocation.target];
            invocation.target = otherTarget;
        }
            break;
        case NSTimerPrettyTypeAutoInvalidate: {
            watcher = [HFWatcher watcherForTarget:invocation.target];
        }
            break;
        case NSTimerPrettyTypeBoth: {
            watcher = [HFWatcher watcherForTarget:invocation.target];
    
            otherTarget = [HFWeakTarget weakTargetFor:invocation.target];
            invocation.target = otherTarget;
        }
            break;
        default:
            break;
    }
    
    NSTimer *timer = [self timerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    if(watcher) {
        watcher.timer = timer;
    }
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType {
    
    HFWatcher *watcher = nil;
    HFWeakTarget *otherTarget = nil;
    
    switch (prettyType) {
        case NSTimerPrettyTypeWeakTarget: {
             otherTarget =  [HFWeakTarget weakTargetFor:invocation.target];
            invocation.target = otherTarget;
        }
            break;
        case NSTimerPrettyTypeAutoInvalidate: {
            watcher = [HFWatcher watcherForTarget:invocation.target];
        }
            break;
        case NSTimerPrettyTypeBoth: {
            watcher = [HFWatcher watcherForTarget:invocation.target];
            
            otherTarget =  [HFWeakTarget weakTargetFor:invocation.target];
            invocation.target = otherTarget;
            
        }
            break;
        default:
            break;
    }
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    if(watcher) {
        watcher.timer = timer;
    }
    return timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType {
    
    HFWatcher *watcher;
    id newTarget = aTarget;
    switch (prettyType) {
        case NSTimerPrettyTypeWeakTarget: {
            HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:aTarget];
            newTarget = otherTarget;
        }
            break;
        case NSTimerPrettyTypeAutoInvalidate: {
                watcher = [HFWatcher watcherForTarget:aTarget];
        }
            break;
        case NSTimerPrettyTypeBoth: {
            watcher = [HFWatcher watcherForTarget:aTarget];
            HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:aTarget];
            newTarget = otherTarget;
            
        }
            break;
        default:
            break;
    }
    
    NSTimer *timer = [self timerWithTimeInterval:ti target:newTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    if(watcher) {
       watcher.timer = timer;
    }
    return timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo prettyType:(NSTimerPrettyType)prettyType {
    HFWatcher *watcher;
    id newTarget = aTarget;
    switch (prettyType) {
        case NSTimerPrettyTypeWeakTarget: {
            HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:aTarget];
            newTarget = otherTarget;
        }
            break;
        case NSTimerPrettyTypeAutoInvalidate: {
            watcher = [HFWatcher watcherForTarget:aTarget];
        }
            break;
        case NSTimerPrettyTypeBoth: {
            watcher = [HFWatcher watcherForTarget:aTarget];
            HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:aTarget];
            newTarget = otherTarget;
            
        }
            break;
        default:
            break;
    }
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:newTarget selector:aSelector userInfo:userInfo repeats:YES];
    if(watcher) {
        watcher.timer = timer;
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
    
    HFWatcher *watcher = [HFWatcher watcherForTarget:aTarget];
    HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:aTarget];
    
    NSTimer *timer = [self hf_timerWithTimeInterval:ti target:otherTarget selector:aSelector userInfo:userInfo repeats:aSelector];
    watcher.timer = timer;
    
    return timer;
}

+ (NSTimer *)hf_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    
    HFWatcher *watcher = [HFWatcher watcherForTarget:aTarget];
    HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:aTarget];
    
    NSTimer *timer = [self hf_scheduledTimerWithTimeInterval:ti target:otherTarget selector:aSelector userInfo:userInfo repeats:aSelector];
    watcher.timer = timer;
    
    return timer;
}
#pragma  mark NSInvocation 模式
+ (NSTimer *)hf_timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
  
    HFWatcher *watcher = [HFWatcher watcherForTarget:invocation.target];
    HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:invocation.target];
    
    invocation.target = otherTarget;
    
    NSTimer *timer = [self hf_timerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
    watcher.timer = timer;
    
    return timer;
}

+ (NSTimer *)hf_scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo {
    
    HFWatcher *watcher = [HFWatcher watcherForTarget:invocation.target];
    HFWeakTarget *otherTarget =  [HFWeakTarget weakTargetFor:invocation.target];
    invocation.target = otherTarget;
    
    NSTimer *timer = [self hf_scheduledTimerWithTimeInterval:ti invocation:invocation repeats:yesOrNo];
        watcher.timer = timer;
    
    return timer;
}

#endif
@end
