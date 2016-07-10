//
//  ViewController.m
//  HFPrettyTimerDemo
//
//  Created by helfy on 16/7/10.
//  Copyright © 2016年 helfy. All rights reserved.
//

#import "ViewController.h"
#import "HFTSubViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testButtonDidTap:(id)sender {
    HFTSubViewController *subViewController = [HFTSubViewController new];
    [self.navigationController pushViewController:subViewController animated:YES];
}

@end
