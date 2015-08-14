//
//  CalendarViewController.m
//  Communication
//
//  Created by helloworld on 15/7/27.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "CalendarViewController.h"
#import "ScheduleViewController.h"
#import "AddCalendarViewController.h"
#import "Header.h"
#import "Datetime.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
@interface CalendarViewController ()

@end

@implementation CalendarViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"日历";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;
        
        UIBarButtonItem * btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        btn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=btn;
        
        UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_btn_white.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(addEvent)];
        right.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=right;

        status=0;
        strYear = [[Datetime GetYear] intValue];
        strMonth = [[Datetime GetMonth] intValue];
        dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
        weekArray=[dayArray copy];
        strWeek=[Datetime GetWeek];
        firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
        numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
    }
    
    return self;
}

-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addEvent
{
//    ScheduleViewController *addEventVC = [[ScheduleViewController alloc] init];
    AddCalendarViewController *addEventVC = [[AddCalendarViewController alloc] init];
    [self.navigationController pushViewController:addEventVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];
    [self drawHeardView];
    [self drawTableView];
    [self AddDaybuttenToCalendarWatch];
    [self AddHandleSwipe];
}

-(void)drawHeardView
{
    heardView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
    heardView.backgroundColor=[UIColor whiteColor];
    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 5, 50,30)];
    [titleLab setText:[NSString stringWithFormat:@"%d月",strMonth]];
    titleLab.font=[UIFont boldSystemFontOfSize:22];
    [heardView addSubview:titleLab];
    
    subLab=[[UILabel alloc]initWithFrame:CGRectMake(12+titleLab.frame.size.width, 5, 50, 35)];
    subLab.numberOfLines=0;
    subLab.text=[NSString stringWithFormat:@"%@%d",strWeek,strYear];
    subLab.font=[UIFont systemFontOfSize:12];
    [heardView addSubview:subLab];
    
    monthBtn=[[UIButton alloc]initWithFrame:CGRectMake(subLab.frame.origin.x+70, 10, 55, 25)];
    [monthBtn setTitle:@"月" forState:UIControlStateNormal];
    monthBtn.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    [monthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    monthBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    monthBtn.layer.borderWidth=1;
    monthBtn.layer.borderColor=COLOR(241.0, 241.0, 241.0, 1).CGColor;
    [monthBtn addTarget:self action:@selector(getDateWithMonth) forControlEvents:UIControlEventTouchUpInside];
    [heardView addSubview:monthBtn];
    
    weekBtn=[[UIButton alloc]initWithFrame:CGRectMake(monthBtn.frame.origin.x+60, 10, 55, 25)];
    [weekBtn setTitle:@"周" forState:UIControlStateNormal];
    [weekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weekBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    weekBtn.layer.borderWidth=1;
    weekBtn.layer.borderColor=COLOR(241.0, 241.0, 241.0, 1).CGColor;
    [weekBtn addTarget:self action:@selector(getDateWithWeek) forControlEvents:UIControlEventTouchUpInside];
    [heardView addSubview:weekBtn];
    
    todayBtn=[[UIButton alloc]initWithFrame:CGRectMake(weekBtn.frame.origin.x+60, 10, 55, 25)];
    [todayBtn setTitle:@"今" forState:UIControlStateNormal];
    [todayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    todayBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    todayBtn.layer.borderWidth=1;
    todayBtn.layer.borderColor=COLOR(241.0, 241.0, 241.0, 1).CGColor;
    todayBtn.backgroundColor=COLOR(35.0, 152.0, 217.0, 1);
    [todayBtn addTarget:self action:@selector(text:) forControlEvents:UIControlEventTouchUpInside];
    todayBtn.tag=0;
    [heardView addSubview:todayBtn];
    
    [self.view addSubview:heardView];
    
    [self AddWeekLableToCalendarWatch];
    
    calenView=[[UIView alloc]initWithFrame:CGRectMake(0, heardView.frame.size.height+64, heardView.frame.size.width, 280)];
    calenView.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    [self.view addSubview:calenView];
}

-(void)drawTableView
{
    if (tableview==nil)
    {
        tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, calenView.frame.origin.y+calenView.frame.size.height, calenView.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:tableview];
    }else
    {
        tableview.frame=CGRectMake(0, calenView.frame.origin.y+calenView.frame.size.height, calenView.frame.size.width, self.view.frame.size.height);
    }
    
}

//制作阳历lable
-(UILabel *)CalendarTitleLabel{
    UILabel* calendarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,80, 24)];
    calendarTitleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    calendarTitleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    //titleLabel.textColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha:1];  //设置文本颜色
    calendarTitleLabel.textColor = [UIColor whiteColor];
    if ((strYear == [[Datetime GetYear] intValue])&&(strMonth ==[[Datetime GetMonth] intValue])){
        calendarTitleLabel.text = [Datetime getDateTime];
    }else {
        if (strMonth < 10) {
            calendarTitleLabel.text = [NSString stringWithFormat:@"%d年  %d月",strYear,strMonth];
        }else calendarTitleLabel.text = [NSString stringWithFormat:@"%d年%d月",strYear,strMonth];
    }
    //设置标题
    
    //calendarTitleLabel.text = [Datetime getDateTime];  //设置标题
    calendarTitleLabel.hidden = NO;
    calendarTitleLabel.tag = 2001;
    calendarTitleLabel.adjustsFontSizeToFitWidth = YES;
    return calendarTitleLabel;
}

//向日历中添加指定月份的日历butten
-(void)AddDaybuttenToCalendarWatch{
    for (int i = 0; i < dayArray.count; i++) {
        UIButton * butten = [[UIButton alloc]init];
        butten.frame = CGRectMake(8+(i%7)*(KSCREENWIDTH-20)/7,(i/7)*(KSCREENWIDTH-20)/7, (KSCREENWIDTH-20)/7, (KSCREENWIDTH-20)/7);
        [butten setTag:i+301];
        //        [butten addTarget:self action:@selector(buttenTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [butten addTarget:self action:@selector(buttenTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        butten.showsTouchWhenHighlighted = YES;
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:dayArray[i]];
        lable.backgroundColor = [UIColor clearColor];
        lable.frame = CGRectMake(((KSCREENWIDTH-20)/7-30)/2, ((KSCREENWIDTH-20)/7-30)/2, 30, 30);
        lable.tag=10;
        lable.layer.cornerRadius=15;
        lable.font=[UIFont systemFontOfSize:13];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.adjustsFontSizeToFitWidth = YES;
        
        if (i<firstWeekDayInmonth||i>=numberOfdaysInmonth+firstWeekDayInmonth)
        {
            lable.textColor = [UIColor grayColor];
        }else
        {
            lable.textColor = [UIColor blackColor];
            if (([[Datetime GetDay] intValue]== [dayArray[i] intValue])&&(strMonth == [[Datetime GetMonth] intValue])&&(strYear == [[Datetime GetYear] intValue])) {
                lable.layer.backgroundColor=COLOR(35.0, 152.0, 217.0, 1).CGColor;
                lable.textColor=[UIColor whiteColor];
                currBtnTag=i+301;
                mark=i+301;
            }
        }
        
        [butten addSubview:lable];
        [calenView addSubview:butten];
    }
}

-(void)buttenTouchUpInsideAction:(id)sender{
    NSInteger i = [sender tag]-301;
    if (i<firstWeekDayInmonth)
    {
        if (strMonth==1)
        {
            strYear--;
            strMonth=12;
        }else
            strMonth--;
        firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
        numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
        [self reloadDateForCalendarWatch];
    }else if(i>=numberOfdaysInmonth+firstWeekDayInmonth)
    {
        if (strMonth==12)
        {
            strYear++;
            strMonth=1;
        }else
            strMonth++;
        firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
        numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
        [self reloadDateForCalendarWatch];

    }else
    {
        UIView * currBtn=[calenView viewWithTag:currBtnTag];
        UILabel * currLab=(UILabel *)[currBtn viewWithTag:10];
        currLab.layer.backgroundColor=[UIColor clearColor].CGColor;
        currLab.textColor=[UIColor blackColor];
        currBtnTag=[sender tag];
        
        UIView * btn=[calenView viewWithTag:[sender tag]];
        UILabel * lab=(UILabel *)[btn viewWithTag:10];
        lab.layer.backgroundColor=COLOR(35.0, 152.0, 217.0, 1).CGColor;
        lab.textColor=[UIColor whiteColor];
        
        if ([sender tag]!=mark&&strMonth==[[Datetime GetMonth] intValue])
        {
            UIView * markBtn=[calenView viewWithTag:mark];
            UILabel * markLab=(UILabel *)[markBtn viewWithTag:10];
            markLab.textColor=COLOR(35.0, 152.0, 217.0, 1);
        }
    }
}

-(void)getDateWithWeek
{
    monthBtn.backgroundColor=[UIColor clearColor];
    weekBtn.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    NSInteger currIndex=mark-301;
    startIndex=currIndex-currIndex%7;
    endIndex=startIndex+7;
    NSMutableArray * arr=[[NSMutableArray alloc]init];
    for (NSInteger i=startIndex; i<=endIndex; i++)
    {
        [arr addObject:weekArray[i]];
    }
    dayArray=nil;dayArray=arr;[self reloadDateWithWeek];
    [UIView beginAnimations:@"short" context:nil];
    [UIView setAnimationDuration:0.5];
    calenView.frame=CGRectMake(0, heardView.frame.origin.y+heardView.frame.size.height, heardView.frame.size.width, 40);
    [self drawTableView];
    [UIView commitAnimations];
    status=1;
}

-(void)getDateWithMonth
{
    strMonth=[[Datetime GetMonth] intValue];strYear=[[Datetime GetYear] intValue];
    //firstWeekDayInmonth=[Datetime getn];
    monthBtn.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    weekBtn.backgroundColor=[UIColor clearColor];
    [self reloadDateForCalendarWatch];
    [UIView beginAnimations:@"short" context:nil];
    [UIView setAnimationDuration:0.5];
    calenView.frame=CGRectMake(0, heardView.frame.origin.y+heardView.frame.size.height, heardView.frame.size.width, 280);
    [self drawTableView];
    [UIView commitAnimations];
    status=0;
}


-(void)text:(UIButton *)sender
{
    if (sender.tag==0)
    {
        
        
        calenView.frame=CGRectMake(0, heardView.frame.origin.y+heardView.frame.size.height, heardView.frame.size.width, 40);
        [self drawTableView];
        sender.tag=1;
    }else
    {
        [UIView beginAnimations:@"long" context:nil];
        [UIView setAnimationDuration:0.5];
        calenView.frame=CGRectMake(0, heardView.frame.origin.y+heardView.frame.size.height, heardView.frame.size.width, 280);
        [self drawTableView];
        sender.tag=0;
        [UIView commitAnimations];
    }
    
}

-(void)reloadDateWithWeek
{
    NSArray * btns=  calenView.subviews;
    for (int i=0; i<dayArray.count; i++)
    {
        UIView * btn= btns[i];
        UILabel * lab=(UILabel *)[btn viewWithTag:10];
        lab.text=[dayArray objectAtIndex:i];
        lab.textColor=[UIColor blackColor];
    }
    [titleLab setText:[NSString stringWithFormat:@"%d月",strMonth]];
    subLab.text=[NSString stringWithFormat:@"%@%d",strWeek,strYear];
}

//在CalendarWatch中重新部署数据
-(void)reloadDateForCalendarWatch{
    dayArray = nil;
    dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
    NSArray * btns=  calenView.subviews;
    
    for (int i=0; i<dayArray.count; i++)
    {
        UIView * btn= btns[i];
        UILabel * lab=(UILabel *)[btn viewWithTag:10];
        lab.text=[dayArray objectAtIndex:i];
        if (i<firstWeekDayInmonth||i>=numberOfdaysInmonth+firstWeekDayInmonth)
        {
            lab.textColor = [UIColor grayColor];
        }else
        {
            lab.textColor=[UIColor blackColor];
        }
        if (strYear==[[Datetime GetYear] intValue]&&strMonth==[[Datetime GetMonth] intValue]&&i==mark-301)
        {
            lab.layer.backgroundColor=COLOR(35.0, 152.0, 217.0, 1).CGColor;
            lab.textColor=[UIColor whiteColor];
            currBtnTag=i+301;
            mark=i+301;
        }else
            lab.layer.backgroundColor=[UIColor clearColor].CGColor;
    }
    [titleLab setText:[NSString stringWithFormat:@"%d月",strMonth]];
    subLab.text=[NSString stringWithFormat:@"%@%d",strWeek,strYear];
}

//添加左右滑动手势
-(void)AddHandleSwipe{
    //声明和初始化手势识别器
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
    //对手势识别器进行属性设定
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //把手势识别器加到view中去
    [calenView addGestureRecognizer:swipeLeft];
    [calenView addGestureRecognizer:swipeRight];
}

//左滑事件
- (void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);
    if (status==1)
    {
        if (endIndex>=numberOfdaysInmonth+firstWeekDayInmonth)
        {
            strMonth = strMonth+1;
            if(strMonth == 13){
                strYear++;strMonth = 1;
            }
            weekArray=[Datetime GetDayArrayByYear:strYear andMonth:strMonth];
            startIndex=7;endIndex=14;
            firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
            numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
            
        }else
        {
            startIndex+=7;endIndex+=7;
        }
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        for (NSInteger i=startIndex; i<endIndex; i++)
        {
            [arr addObject:weekArray[i]];
        }
        dayArray=nil;dayArray=arr;[self reloadDateWithWeek];
        return;
    }
    strMonth = strMonth+1;
    if(strMonth == 13){
        strYear++;strMonth = 1;
    }
    firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
    numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
    //NSLog(@"%d,%d",strYear,strMonth);
    [self reloadDateForCalendarWatch];
}
//右滑事件
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%u",gestureRecognizer.direction);
    if (status==1)
    {
        if (endIndex==7)
        {
            strMonth = strMonth-1;
            if(strMonth == 0){
                strYear--;strMonth = 12;
            }
            weekArray=[Datetime GetDayArrayByYear:strYear andMonth:strMonth];
            firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
            numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
            if (firstWeekDayInmonth+numberOfdaysInmonth<=35)
            {
                startIndex=21;endIndex=28;
            }else
            {
                startIndex=28;endIndex=35;
            }
        }else
        {
            startIndex-=7;endIndex-=7;
        }
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        for (NSInteger i=startIndex; i<endIndex; i++)
        {
            [arr addObject:weekArray[i]];
        }
        dayArray=nil;dayArray=arr;[self reloadDateWithWeek];
        return;
    }
    strMonth = strMonth-1;
    if(strMonth == 0){
        strYear--;strMonth = 12;
    }
    firstWeekDayInmonth=[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
    numberOfdaysInmonth=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
    //NSLog(@"%d,%d",strYear,strMonth);
    [self reloadDateForCalendarWatch];
}

//向日历中添加星期标号（周日到周六）
-(void)AddWeekLableToCalendarWatch{
    NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    for (int i = 0; i < 7; i++) {
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:array[i]];
        lable.font=[UIFont systemFontOfSize:13];
        if (i==0||i==6) {
            lable.textColor = [UIColor redColor];
        }else
            lable.textColor = [UIColor blackColor];
        
        lable.backgroundColor = [UIColor clearColor];
        lable.frame = CGRectMake(12+i*(KSCREENWIDTH-20)/7, 94, (KSCREENWIDTH-20)/7, (KSCREENWIDTH-20)/7);
        lable.adjustsFontSizeToFitWidth = YES;
        lable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lable];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
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
