//
//  Callrecords.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Callrecords.h"


#import "ConverseViewController.h"
#import "OperateViewController.h"
#import "CalendarcomViewController.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface Callrecords ()
{
    ConverseViewController *page1;
    OperateViewController *page2;
    CalendarcomViewController *page3;
}
@end

@implementation Callrecords

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"通讯助手";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    self.childView = [[UIView alloc]initWithFrame:CGRectMake(0, 94,self.view.frame.size.width,self.view.frame.size.height  - 64)];
    //    self.childView.backgroundColor = kRed;
    [self.view addSubview:self.childView];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"通话记录",@"操作记录",@"日历记录",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc ] initWithItems: segmentedArray ];
    segmentedControl.frame = CGRectMake(1, 66, self.view.frame.size.width - 1*2, 30);
    segmentedControl.tintColor = [UIColor grayColor];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    page1 = [[ConverseViewController alloc]init];
    page2 = [[OperateViewController alloc]init];
    page3 = [[CalendarcomViewController alloc]init];
    [self.childView addSubview:page1.view];
    
    
//    int count = 3;
//    CGFloat ButtonX = KSCREENWIDTH/3;
//    CGFloat ButtonH = 40;
//    
//    NSArray *imgArray = [NSArray  arrayWithObjects:@"record_call_icon_pru.png",@"record_operate_icon_pru.png ",@"record_calendar_icon_pru.png", nil];
//    NSArray *selectimgArray = [NSArray arrayWithObjects:@"record_call_icon.png",@"record_operate_icon.png",@"record_calendar_icon.png ",nil];
//    NSArray *titleArray = [NSArray arrayWithObjects:@"通话",@"操作",@"日历",nil];
//    
//    
//    for (int i=0; i<3; i++) {
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ButtonX, ButtonH)];
//        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:selectimgArray[i]] forState:UIControlStateSelected];
////        button.backgroundColor = [UIColor redColor];
//
//        [button setTitle:titleArray[i] forState:UIControlStateNormal];
//        [self.view addSubview:button];
//    }
    
}
-(void)selected:(id)sender{
    
    [page1.view removeFromSuperview];
    [page2.view removeFromSuperview];
    [page3.view removeFromSuperview];
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
        {
            
            [self.childView addSubview:page1.view];
        }
            break;
        case 1:
        {
            
            [self.childView addSubview:page2.view];
            
        }
            break;
        case 2:
        {
            [self.childView addSubview:page3.view];
            
        }
            break;
            
        default:
            break;
    }}

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
