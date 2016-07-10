//
//  HFTSubViewController.m
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "HFTSubViewController.h"
#import "NSTimer+HF.h"
@interface HFTSubViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HFTSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) dealloc {
    NSLog(@"timer持有者被释放");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startTimer:(id)sender {
    
        SEL sel = @selector(changNumber);
        NSMethodSignature * sig = [[self class]  instanceMethodSignatureForSelector: sel];
        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature: sig];
        [myInvocation setTarget: self];
        [myInvocation setSelector:  sel];
        self.timer = [NSTimer timerWithTimeInterval:1 invocation:myInvocation repeats:YES];
        
        //    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeToLabelTwo) userInfo:nil repeats:YES];
        
        //    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(changeToLabelTwo) userInfo:Nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}

- (void)changNumber {
    
    NSLog(@"changNumber");
}
@end
