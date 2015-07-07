//
//  Newcustomer.m
//  Communication
//
//  Created by CIO on 15/2/10.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Newcustomer.h"

@interface Newcustomer ()

@end

@implementation Newcustomer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"新建客户";
//    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonreturn:)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"呼入.png"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonreturn:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UITabBarSystemItemSearch target:self action:@selector(leftButtonreturn:)];

}
-(void)leftButtonreturn:(UIBarButtonItem*)left{
    [self.navigationController popViewControllerAnimated:YES];
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
