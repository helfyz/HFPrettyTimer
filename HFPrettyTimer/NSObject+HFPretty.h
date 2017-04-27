//
//  NSObject+HFPretty.h
//  HFPrettyTimerDemo
//
//  Created by charles on 16/7/24.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern char *const HFWeakenIdentifier;

#define PrettyTimer(x)\
autoreleasepool {}\
__strong NSObject *strongX __attribute__((cleanup(removeWeakenIdentifier))) = x;\
objc_setAssociatedObject(strongX, HFWeakenIdentifier, @"", OBJC_ASSOCIATION_COPY_NONATOMIC);\

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

static void removeWeakenIdentifier(__strong id *target) {
    objc_setAssociatedObject(*target, HFWeakenIdentifier, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma clang diagnostic pop

@interface NSObject (HFPretty)

- (BOOL)shouldWeaken;

@end
