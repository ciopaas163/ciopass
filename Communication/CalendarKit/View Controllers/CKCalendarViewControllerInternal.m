//
//  CKViewController.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarViewControllerInternal.h"

#import "CKCalendarView.h"

#import "CKCalendarHeaderView.h"

#import "CKCalendarEvent.h"

#import "NSCalendarCategories.h"

#import "ScheduleViewController.h"  //添加事件

#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height

@interface CKCalendarViewControllerInternal () <CKCalendarViewDataSource, CKCalendarViewDelegate>
{
    UIButton *currentButton;
   
}
@property (nonatomic, strong) CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;

@property (nonatomic,strong) CKCalendarHeaderView *headView;

@end

@implementation CKCalendarViewControllerInternal 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTranslucent:NO];//默认带有一定透明效果，可以使用以下方法去除系统效果

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self usenagation];   //导航栏
    
    /* Prepare the events array */
    
    [self setEvents:[NSMutableArray new]];
    
    [self toubu];  //天、周 、月

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    
}


#pragma mark 添加视图

-(void)viewWillAppear:(BOOL)animated
{
    /* Calendar View */
    
    [[self calendarView]reload];
    
    [self setCalendarView:[CKCalendarView new]];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    [[self view] addSubview:[self calendarView]];
    
   

    
    [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    [[self calendarView] setDisplayMode:CKCalendarViewModeMonth animated:NO];
    
}

#pragma mark 导航栏
-(void)usenagation
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];//allocate
    //Create UILable
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(50, 0, 100, 20)];//allocate titleText
    titleText.textColor = [UIColor whiteColor];
    titleText.textAlignment = NSTextAlignmentCenter;
    
//    NSString *title = [CKCalendarView sharDatabase].titleHeader
    [titleText setText:@"2015年3月"];
    [titleView addSubview:titleText];
    
   

    
    
    UIButton *btnNormal = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnNormal setFrame:CGRectMake(0, 0, 40, 20)];
    [btnNormal setImage:[UIImage imageNamed:@"左.png"] forState:UIControlStateNormal];
    [btnNormal addTarget:self action:@selector(backwardButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btnNormal];
    
    UIButton *youNormal = [UIButton buttonWithType:UIButtonTypeCustom];
    [youNormal setFrame:CGRectMake(200-40, 0,40, 20)];
    [youNormal setImage:[UIImage imageNamed:@"右.png"] forState:UIControlStateNormal];
    [youNormal addTarget:self action:@selector(forwardButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:youNormal];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREENWIDTH/6*5+20,7, 25, 25)];
    [addButton setImage:[UIImage imageNamed:@"添加白.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:addButton];
    self.navigationItem.titleView = titleView;
}

#pragma mark 周、月、天  

-(void)toubu
{
    CGFloat buttonY = 5;
    CGFloat buttonH = 30;
    
    CGFloat labelY = buttonH+5;
    
    CGFloat touViewH =labelY;
    
    UIView *touView = [[UIView alloc]initWithFrame:CGRectMake(0,0,KSCREENWIDTH, touViewH)];
    //    touView.layer.borderWidth = 1;
    
    [self.view addSubview:touView];
    
   
    
    
    //月 周 日 今天 按钮
    NSArray *timeArray = [NSArray arrayWithObjects:@"月",@"周",@"日",@"今",nil];
    
    for (NSInteger i=0; i<4; i++)
    {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(8*(i+1)+i*(KSCREENWIDTH-40)/4,buttonY, (KSCREENWIDTH-40)/4, buttonH)];
        [but setTitle:timeArray[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        but.layer.borderWidth = 1.0f;
        but.tag = i;
        but.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]CGColor];
        if (i==3)
        {
            but.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
        [but addTarget:self action:@selector(useBBut:) forControlEvents:UIControlEventTouchUpInside];
        if (but.tag==0)
        {
            UIButton *monbut = (UIButton *)but;
            currentButton = monbut;
            currentButton.selected = YES;
            [self useBut:currentButton];
        }
        
        [touView addSubview:but];
        
    }
    
    
}

#pragma mark 下一月 上一月

-(void)useBBut:(UIButton *)sender
{
    if (sender.tag<3)
    {
        if (sender != currentButton)
        {
            currentButton.selected = NO;
            [currentButton setBackgroundColor:[UIColor clearColor]];
            currentButton = sender;
        }
        currentButton.selected = YES;
        [currentButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    switch (sender.tag) {
        case 0:
            [[self calendarView] setDisplayMode:0];
            break;
        case 1:
            [[self calendarView] setDisplayMode:1];
            break;
        case 2:
            [[self calendarView] setDisplayMode:2];
            break;
            
        default:
            [[self calendarView] setDate:[NSDate date] animated:NO];
            break;
    }
    
}

#pragma mark - Button Handling  按钮的处理

- (void)forwardButtonTapped
{
    
    [[self calendarView] forwardTapped];
}

- (void)backwardButtonTapped
{
    [[self calendarView] backwardTapped];
}


#pragma mark 添加事件

-(void)addButtonClick:(UIButton *)sender
{
    ScheduleViewController *scheduleView = [[ScheduleViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:scheduleView];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)useBut:(UIButton *)sender
{
    if (sender.tag<3)
    {
        if (sender != currentButton)
        {
            currentButton.selected = NO;
            [currentButton setBackgroundColor:[UIColor clearColor]];
            currentButton = sender;
        }
        currentButton.selected = YES;
        [currentButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
        switch (sender.tag) {
            case 0:
                [[self calendarView] setDisplayMode:0];
                break;
            case 1:
                [[self calendarView] setDisplayMode:1];
                break;
            case 2:
                [[self calendarView] setDisplayMode:2];
                break;
                
            default:
                [[self calendarView] setDate:[NSDate date] animated:NO];
                break;
        }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)CalendarView eventsForDate:(NSDate *)date
{
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        return [[self dataSource] calendarView:CalendarView eventsForDate:date];
    }
    return nil;
}

#pragma mark - CKCalendarViewDelegate 代理

// Called before the selected date changes 改变之前选择的日期
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [[self delegate] calendarView:calendarView willSelectDate:date];
    }
}

// Called after the selected date changes 所选日期的变化称为
- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:calendarView didSelectDate:date];
    }
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)一行是在事件表中选择。（利用推详细查看或什么的。）
- (void)calendarView:(CKCalendarView *)calendarView didSelectEvent:(CKCalendarEvent *)event
{
    if ([self isEqual:[self delegate]]) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [[self delegate] calendarView:calendarView didSelectEvent:event];
    }
}

#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}

- (CKCalendarHeaderView *)headView
{
    return _headView;
}

#pragma mark - Orientation Support

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [[self calendarView] reloadAnimated:NO];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[self calendarView] reloadAnimated:NO];
}

@end
