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
    HFWeakensTarget *weakens = [[HFWeakensTarget alloc] init];
    weakens.target = target;
    return weakens;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}


@end
