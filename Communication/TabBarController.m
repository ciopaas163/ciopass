//
//  TabBarController.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "TabBarController.h"            //通讯录   【个人】
#import "EnterpriseController.h"  //通讯录  【企业】
#import "KeyViewController.h"   //拨号盘
#import "Callrecords.h"//动态记录
#import "ZYHMunViewController.h"//沟通
//#import "Thecalendar.h"          //日历

#import "MyInfoViewController.h"

@interface TabBarController ()
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation TabBarController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        CGRect frame = CGRectMake(0, 0, 320, 49);
        
        UIView *v = [[UIView alloc] initWithFrame:frame];
        v.backgroundColor=[UIColor whiteColor];
        [self.tabBar insertSubview:v atIndex:0];
        
        //self.tabBar.opaque = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController* Entnav = [[UINavigationController alloc] initWithRootViewController:[[EnterpriseController alloc] init]];
    _nav1 = [[UINavigationController alloc] initWithRootViewController:[[KeyViewController alloc] init]];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:[[ZYHMunViewController alloc] init]];
    //    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[[Thecalendar alloc] init]];
    
    UINavigationController * nav3=[[UINavigationController alloc]initWithRootViewController:[[MyInfoViewController alloc]init]] ;
    //self.viewController = [CKDemoViewController new];
    
    //通讯录  【企业】
    Entnav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:[UIImage imageNamed:@"contact-gray.png"]selectedImage:[UIImage imageNamed:@"contact-blue.png"]];
    
    //    拨号盘
    _nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"拨号盘" image:[UIImage imageNamed:@"keyboard-gray.png"] selectedImage:[UIImage imageNamed:@"keyboard-blue.png"]];
    
    //    动态记录
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"沟通" image:[UIImage imageNamed:@"recentdynamic-gray.png"] selectedImage:[UIImage imageNamed:@"recentdynamic-blue.png"]];
    
    //    我的info
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"calender-gray.png"] selectedImage:[UIImage imageNamed:@"calender-blue.png"]];
    
    self.viewControllers = @[Entnav,_nav1,nav2,nav3];
    
    
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
