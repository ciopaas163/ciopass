//
//  MethodController.m
//  Communication
//
//  Created by CIO on 15/2/3.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "MethodController.h"
#import "SetupController.h"

@interface MethodController ()

@end

@implementation MethodController

static MethodController  *instans = nil;
+(MethodController *)sharedpupsviewcontroller{

    if (!instans) {
        instans = [[self alloc] init];
    }
    //
    return instans;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    instans = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leftButton:(UIBarButtonItem*)click{ //导航栏左边的按钮;
 UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(retuButton:)];
}

#pragma mark 按钮
-(void)retuButton:(UIBarButtonItem*)leftbutton{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButton:(UIBarButtonItem*)click{  //导航栏左边的按钮;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"] style:UIBarButtonItemStylePlain target:self action:@selector(perFormSetup:)];

}

#pragma mark  --- 设置按钮
-(void)perFormSetup:(UISegmentedControl*)Setup{
    NSLog(@"Setup:设置");
    SetupController* sevc = [[SetupController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sevc];

    [self.navigationController presentViewController:nav animated:YES completion:nil];

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
