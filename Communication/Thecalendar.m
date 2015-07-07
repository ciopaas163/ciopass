//
//  Thecalendar.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Thecalendar.h"
#import "ScheduleViewController.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface Thecalendar ()

@property (nonatomic,strong)UIView *navigationbarView;
@end

@implementation Thecalendar

-(void)viewWillAppear:(BOOL)animated{
       [self.navigationController.navigationBar setHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(Setupbtn:)];

    
    NSDateFormatter* newDate  = [[NSDateFormatter alloc]init];
    [newDate setDateFormat:@"yyy年MM月"];
    NSString* strDate = [newDate stringFromDate:[NSDate date]];
    startTimer = strDate;
    NSLog(@"startTimer:%@",startTimer);
    
    _btnTimer = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTimer.frame = CGRectMake(self.view.frame.size.width / 2 - 100/2, 5, 100, 64 - 10 *3);
//    _btnTimer.backgroundColor = [UIColor redColor];
    [_btnTimer setTitle:startTimer forState:UIControlStateNormal];
    _btnTimer.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_btnTimer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnTimer.tag = 500;
    [_btnTimer addTarget:self action:@selector(timerBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _btnTimer;

    //图片
    UIImageView* imgPrompt = [[UIImageView alloc]initWithFrame:CGRectMake(_btnTimer.frame.size.width / 2 - 25 / 2, _btnTimer.frame.origin.y + 12, 25, 25)];
    imgPrompt.image = [UIImage imageNamed:@"向下.9.png"];
    imgPrompt.backgroundColor = [UIColor clearColor];
//    self.navigationItem.titleView = imgPrompt;
    [_btnTimer addSubview:imgPrompt];
}

-(void)adcButton:(UIButton*)tbb{
    if (tbb.tag == 10) {
        NSLog(@"选1");
    }else if (tbb.tag ==2){
        NSLog(@"选中2");
    }

}
#pragma mark  --- 设置按钮
-(void)Setupbtn:(UISegmentedControl*)Setup{
    NSLog(@"Setup:设置");

    ScheduleViewController*   scheduleView = [[ScheduleViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:scheduleView];
//    [self.navigationController pushViewController:nav animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark --- 【 UIButton 】
-(void)timerBtn:(UIButton*)timer{
    switch (timer.tag) {
        case 500:{
            NSLog(@"500");
            
            [self  Timescrollbar];
             
        }
            break;
        case 501:{
              NSLog(@"501");
        }
            break;
        case 502:{
              NSLog(@"502");
        }
            break;
        case 503:{
              NSLog(@"503");
        }
            break;
        case 504:{
              NSLog(@"504");
        }
            break;
        default:
            break;
    }
}

#pragma mark ---  【 时间滚动栏  Timescrollbar 】
-(void)Timescrollbar{
    //    dateView  是放置 UIDatePicker和 确定取消button
    dateView = [[UIView alloc]initWithFrame:CGRectMake(0, _btnTimer.frame.origin.y + _btnTimer.frame.size.height * 6 + 20, self.view.frame.size.width, _btnTimer.frame.size.height * 6 + 15)];
    dateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dateView];

    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, dateView.bounds.origin.y + 40 , dateView.frame.size.width , dateView.frame.size.height - 60)];
    NSLog(@"kuan:%f",_datePicker.frame.size.height);
    _datePicker.backgroundColor = [UIColor clearColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(datePickChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.userInteractionEnabled = YES;
    [dateView addSubview:_datePicker];
    
    //确定
    NSArray* btnText = @[@"确定",@"取消"];
    for (int i = 0; i <2; i++) {
        btncancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btncancel.frame = CGRectMake( 25 + i * (50 + 172), dateView.bounds.origin.y , 50, 30);
        btncancel.backgroundColor = [UIColor clearColor];
        [btncancel setTitle:btnText[i] forState:UIControlStateNormal];
        [btncancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        btncancel.tag = 600+i;
        [btncancel addTarget:self action:@selector(btnDateTrmer:) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:btncancel];
    }
}

#pragma mark === [datePickChanged  时间 ]
-(void)datePickChanged:(UIDatePicker*)datepick{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:datepick.date];
    
    _strTimer = [NSString stringWithFormat:@"%ld年%ld月",(long)[components year],(long)[components month]];
    
    NSLog(@"时间:%@",_strTimer);
    
//    [_btnTimer setTitle:_strTimer forState:UIControlStateNormal];
    
}
-(void)btnDateTrmer:(UIButton*)timerDetermine{
    if (timerDetermine.tag==600)
    {
       
    }
    else
    {
        
    }

    [dateView removeFromSuperview];
    
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
