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

@property (nonatomic, strong, readwrite) NSMutableArray *detectedHandlers;

@end

@implementation HFDeallocDetector {
    
    dispatch_semaphore_t _lock;
}
- (instancetype)initWithTarget:(id)tetget deallocDetectedHandler:(HFDeallocDetectedBlock)handler{
    self = [super init];
    if(self) {
        
        _detectedHandlers = [NSMutableArray array];
        _lock = dispatch_semaphore_create(1);
        [self addDetectedHandler:handler];
    }
    return self;
}

- (void)addDetectedHandler:(HFDeallocDetectedBlock)deallocDetectedHandler {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self.detectedHandlers addObject:deallocDetectedHandler];
    dispatch_semaphore_signal(_lock);
}

- (void)dealloc {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    for (HFDeallocDetectedBlock handeler in self.detectedHandlers) {
        handeler();
    }
    [self.detectedHandlers removeAllObjects];
    dispatch_semaphore_signal(_lock);
}

+ (HFDeallocDetector *)detectorForTarget:(id)target deallocDetectedHandler:(HFDeallocDetectedBlock)handler; {
    
   HFDeallocDetector *detector = objc_getAssociatedObject(target, @selector(selecotrForDetector));
    if(detector == nil) {
        detector = [[HFDeallocDetector alloc] initWithTarget:target deallocDetectedHandler:handler];
        objc_setAssociatedObject(target, @selector(selecotrForDetector), detector, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        [detector addDetectedHandler:handler];
    }
    return detector;
}

- (void)selecotrForDetector {
}

@end
