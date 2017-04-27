//
//  HFTSubViewController.m
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTSubViewController.h"
#import "NSTimer+HFPretty.h"
#import "HFWeakensTarget.h"
#import "HFDeallocDetector.h"
@interface HFTSubViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer1;

@end

@implementation HFTSubViewController

- (IBAction)startTimer:(id)sender {
    @PrettyTimer(self)
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeNumber) userInfo:nil repeats:YES];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeNumber1) userInfo:nil repeats:YES];
////        SEL sel = @selector(changNumber);
//        NSMethodSignature * sig = [[self class]  instanceMethodSignatureForSelector: sel];
//        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature: sig];
//        [myInvocation setTarget: self];
//        [myInvocation setSelector:  sel];
//        self.timer = [NSTimer timerWithTimeInterval:1 invocation:myInvocation repeats:YES prettyStrategy:HFTimerStrategyAutoInvalidate];
//    
////            self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changNumber) userInfo:nil repeats:YES prettyType:HFTimerStrategyBoth];
//    
////            self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changNumber) userInfo:nil repeats:YES];
//    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSDefaultRunLoopMode];
    [self.timer fire];
    [self.timer1 fire];
  
}

- (void)changeNumber {
    NSLog(@"changNumber");
}

- (void)changeNumber1 {
    NSLog(@"changNumber1");
}

- (void)dealloc {
    NSLog(@"%@ dealloc",self.class);
}
@end
