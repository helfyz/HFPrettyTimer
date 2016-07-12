//
//  HFWeakensTarget.h
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/12.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFWeakensTarget : NSObject

@property (nonatomic, weak) id target;

/**
 *  弱化一个target 的引用
 *
 *  @param target 对象
 *
 *  @return 弱化后的实例对象
 */
+ (HFWeakensTarget *)weakensTarget:(id)target;
@end
