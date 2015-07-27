//
//  secondViewController.m
//  vibgyor_mapview
//
//  Created by Anurag Mishra on 7/25/15.
//  Copyright (c) 2015 mojers. All rights reserved.
//

#import "secondViewController.h"

@interface secondViewController ()

@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reminderButton:(UIButton *)sender {
    NSLog(@"Button pressed!");
    self.label2.text = @"Hello World!";
    NSDate *date = [[NSDate alloc] init];
    NSLog (@"%f", date.timeIntervalSince1970);
    self.label2.text = [[NSString alloc] initWithFormat:@"Date is %.2f", date.timeIntervalSince1970];
}

@end
