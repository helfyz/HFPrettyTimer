//
//  HFWeakensTarget.m
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/12.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFWeakensTarget.h"

@implementation HFWeakensTarget

+ (HFWeakensTarget *)weakensTarget:(id)target {
    HFWeakensTarget *weakens = [HFWeakensTarget new];
    weakens.target = target;
    return weakens;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

- (Class)class {
    return [self.target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self.target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [self.target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self.target conformsToProtocol:aProtocol];
}

- (NSString *)description {
    return [self.target description];
}

@end
