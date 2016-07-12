//
//  HFDeallocDetector.m
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/12.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFDeallocDetector.h"
#import <objc/runtime.h>
@implementation HFDeallocDetector

+ (HFDeallocDetector *)detectorForTarget:(id)target targetDealloc:(void(^)(void)) targetDealloc {
    
    HFDeallocDetector *detector = [[HFDeallocDetector alloc] initWithTarget:target targetDealloc:targetDealloc];
    objc_setAssociatedObject(target, @selector(selecotrForDetector), detector, OBJC_ASSOCIATION_RETAIN);
    return detector;
}

- (void)selecotrForDetector {
    
}

- (instancetype)initWithTarget:(id)tetget targetDealloc:(void(^)(void))targetDealloc {
    
    self = [super init];
    if(self) {
        _targetDealloc = targetDealloc;
    }
    return self;
}

- (void)dealloc {
    !_targetDealloc?:_targetDealloc();
}
@end
