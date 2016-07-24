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

+ (HFWeakensTarget *)weakensTarget:(id)target;

@end
