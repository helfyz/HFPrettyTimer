//
//  NSObject+HFPretty.m
//  HFPrettyTimerDemo
//
//  Created by charles on 16/7/24.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "NSObject+HFPretty.h"

char *const HFWeakenIdentifier = "57fb44e903ebfc31d01d568fbbb2006b"; //handsomeCharles :)

@implementation NSObject (HFPretty)

- (BOOL)shouldWeaken {
    id obj = objc_getAssociatedObject(self, HFWeakenIdentifier);
    return obj != nil;
}

- (void)addWeakenIndentifier {
    __strong NSObject *strongSelf __attribute__((cleanup(removeWeakenIdentifier))) = self;
    objc_setAssociatedObject(strongSelf, HFWeakenIdentifier, @"", OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
