//
//  HFDeallocDetector.h
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/12.
//  Copyright © 2016年 helfy. All rights reserved.
//
#import <Foundation/Foundation.h>



typedef void (^HFDeallocDetectedBlock)(void);

@interface HFDeallocDetector : NSObject

@property (nonatomic, strong, readonly) HFDeallocDetectedBlock deallocDetectedHandler;

/**
 *  观察一个target是否释放，释放后调用block,如果target 已经在探测中，handler 会累积
 *
 *  @param target        检测对象
 *  @param targetDealloc 回调方法
 *
 *  @return 实例对象
 */
+ (HFDeallocDetector *)detectorForTarget:(id)target deallocDetectedHandler:(HFDeallocDetectedBlock)handler;

@end
