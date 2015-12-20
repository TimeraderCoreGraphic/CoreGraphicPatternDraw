//
//  ViewController.m
//  PatternDraw
//
//  Created by 李佳 on 15/12/20.
//  Copyright © 2015年 LiJia. All rights reserved.
//

#import "ViewController.h"
#import "TimPatternDrawView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TimPatternDrawView* showView = [[TimPatternDrawView alloc] init];
    showView.backgroundColor = [UIColor whiteColor];
    showView.frame = self.view.frame;
    
    [self.view addSubview:showView];
}



@end
