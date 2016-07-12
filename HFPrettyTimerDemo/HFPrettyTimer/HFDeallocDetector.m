//
//  HFDeallocDetector.m
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/12.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFDeallocDetector.h"
#import <objc/runtime.h>

@interface HFDeallocDetector ()

@property (nonatomic, strong, readwrite) HFDeallocDetectedBlock deallocDetectedHandler;

@end

@implementation HFDeallocDetector

- (instancetype)initWithTarget:(id)tetget deallocDetectedHandler:(HFDeallocDetectedBlock)handler{
    self = [super init];
    if(self) {
        _deallocDetectedHandler = handler;
    }
    return self;
}

- (void)dealloc {
    _deallocDetectedHandler? : _deallocDetectedHandler();
}

+ (HFDeallocDetector *)detectorForTarget:(id)target deallocDetectedHandler:(HFDeallocDetectedBlock)handler; {
    HFDeallocDetector *detector = [[HFDeallocDetector alloc] initWithTarget:target deallocDetectedHandler:handler];
    objc_setAssociatedObject(target, @selector(selecotrForDetector), detector, OBJC_ASSOCIATION_RETAIN);
    return detector;
}

- (void)selecotrForDetector {
}

@end
