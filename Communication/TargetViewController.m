//
//  TargetViewController.m
//  Communication
//
//  Created by CIO on 15/3/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "TargetViewController.h"

@interface TargetViewController ()

@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"目标客户";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(rightBarbtnItem:)];
self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonSystemItemPageCurl target:self action:@selector(rightBarbtnItem:)];
}
#pragma mark -- [rightBarBtnItem]
-(void)rightBarbtnItem:(UIBarButtonItem*)barButtonItem{
    NSLog(@"完成");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
