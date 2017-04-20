//
//  ViewController.m
//  BaiduMap
//
//  Created by MM on 17/4/20.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "MainViewController.h"
#import "MMMapLocationViewController.h"
#import "SecViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)gotoMap:(UIButton *)sender {
    MMMapLocationViewController *mapVC = [[MMMapLocationViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
}



@end
