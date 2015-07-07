//
//  CKDemoViewController.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKDemoViewController.h"

#import "NSCalendarCategories.h"

#import "NSDate+Components.h"

#import "Database.h"  //数据库获取数据
#import "FMDatabase.h"
#import "ScheduleModel.h"

#import "NSDate+Description.h"  //日期转换

#import "ScheduleViewController.h"   //添加事件

@interface CKDemoViewController () <CKCalendarViewDelegate, CKCalendarViewDataSource>
{
     NSUserDefaults *userDefaults;
}
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSMutableArray *dataSources;
@end

@implementation CKDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /**
     *  Create a dictionary for the data source
     */
    
    self.data = [[NSMutableDictionary alloc] init];
    
    /**
     *  Wire up the data source and delegate.
     */
    
    /**
     *  Create some events.
     */
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadMovieDataFromDB];
    [[self calendarView]reload];
}

#warning 单例获取数据库中的数据

- (void)loadMovieDataFromDB
{
    [[self data]removeAllObjects];
    [self setDataSource:self];
    [self setDelegate:self];
    
    Database *db = [Database sharDatabase];
    NSLog(@"allSchedule = %@",[db allSchedule]); //打印所有数据事件
    
    NSString *title;
    NSInteger year=0;
    NSInteger month=0;
    NSInteger day=0;
    NSString *dangd;
    NSDate *data;
    
    if ([db allSchedule].count>0)
    {
        NSArray *ScheduleArray = [db allSchedule];
        
        for (NSDictionary *dic in ScheduleArray)
        {
            ScheduleModel *model =(ScheduleModel*)dic;
            //标题
           title = [NSString stringWithFormat:@"%@",model.title];
            
            NSString *begintime = [NSString stringWithFormat:@"%@",model.begin_time];
            
            NSTimeInterval timeInterval = [begintime integerValue];
            
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            
            //开始时间日期
            NSDate *now = date2;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            year = [dateComponent year];
            month = [dateComponent month];
            day = [dateComponent day];
            //            NSInteger hour = [dateComponent hour];
            //            NSInteger minute = [dateComponent minute];
            //            NSInteger second = [dateComponent second];
        
            //添加开始时间当天0点时间
            dangd = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00",(long)year,(long)month,(long)day];
        
            //添加时间当天0点时间时间戳
            long dangdx = [self useTime:dangd];
            long dangdx2 = dangdx+86400;
            
            //查询开始时间的当天数据
            NSString *sql = [NSString stringWithFormat:@"select * from Schedule where begin_time between %ld and %ld order by begin_time ASC",dangdx,dangdx2];
            NSArray *dayScheduleArray =[db searchMovieByName:sql];
            NSMutableArray *enventArray = [NSMutableArray array];
            
            for (NSDictionary *dic in dayScheduleArray)
            {
                ScheduleModel *model =(ScheduleModel*)dic;
                //标题
                title = [NSString stringWithFormat:@"%@",model.title];
                //开始时间
                begintime = [NSString stringWithFormat:@"%@",model.begin_time];
                //事件日期
                data = [NSDate dateWithDay:day month:month year:year];
                
                CKCalendarEvent *Kit = [CKCalendarEvent eventWithTitle:title andDate:data andInfo:dic];
                [enventArray addObject:Kit];
            }
            //添加数据源数组
            self.data[data] = [NSArray arrayWithArray:enventArray];
        }
    }
    
#warning 事件数据源打印
    
//    NSLog(@"事件数据源 self data = %@",[self data]);

}

#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    return [self data][date];
}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{

}
- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{

}

//  A row is selected in the events table. (Use to push a detail view or whatever.)

#warning 选中某个事件
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    
    ScheduleModel *model =(ScheduleModel*)[event info];
    NSLog(@"sysid = %@",model.sysID);
    
    ScheduleViewController *vc = [[ScheduleViewController alloc]init];
    vc.sysID = model.sysID;
    
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}

#pragma mark 时间转时间戳

-(int)useTime:(NSString *)str
{
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromdate=[format dateFromString:str];
//    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
//    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
//    NSDate *fromDate = [fromdate dateByAddingTimeInterval: frominterval];

    //时间转时间戳
    NSTimeInterval timeInterval2 = (int)[fromdate timeIntervalSince1970];
//    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval2];  //时间戳转时间
    return timeInterval2;
}

- (void)viewDidAppear:(BOOL)animated
{
    /**
     * Here's an example of setting min/max dates.
     */
    
    /*
     NSDate *min = [NSDate dateWithDay:1 month:4 year:2014];
     NSDate *max = [NSDate dateWithDay:31 month:12 year:2015];
     
     [[self calendarView] setMaximumDate:max];
     [[self calendarView] setMinimumDate:min];
     */
    
}

/*
 #warning  时间转换
 -(void)usetime
 {
 NSString *dateStr=@"2015-03-04 10:38:00";//传入时间
 //将传入时间转化成需要的格式
 NSDateFormatter *format=[[NSDateFormatter alloc] init];
 [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate *fromdate=[format dateFromString:dateStr];
 NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
 NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
 NSDate *fromDate = [fromdate dateByAddingTimeInterval: frominterval];
 NSLog(@"fromdate=%@",fromDate);
 
 //获取当前时间
 NSDate *date = [NSDate date];
 NSTimeZone *zone = [NSTimeZone systemTimeZone];
 NSInteger interval = [zone secondsFromGMTForDate: date];
 NSDate *localeDate = [date dateByAddingTimeInterval: interval];
 NSLog(@"enddate=%@",localeDate);
 
 
 //获取当前时间
 NSDate *now = [NSDate date];
 NSLog(@"now date is: %@", now);
 
 NSCalendar *calendar = [NSCalendar currentCalendar];
 NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
 NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
 
 NSInteger year = [dateComponent year];
 NSInteger month = [dateComponent month];
 NSInteger day = [dateComponent day];
 NSInteger hour = [dateComponent hour];
 NSInteger minute = [dateComponent minute];
 NSInteger second = [dateComponent second];
 
 NSLog(@"year is: %ld", (long)year);
 NSLog(@"month is: %ld", (long)month);
 NSLog(@"day is: %ld", (long)day);
 NSLog(@"hour is: %ld", (long)hour);
 NSLog(@"minute is: %ld", (long)minute);
 NSLog(@"second is: %ld", (long)second);
 
 }
 */



/*
 //数据事件  数据库中取得数据
 
 Database *db = [Database shareDatabase];
 //    NSLog(@"allSchedule = %@",[db allSchedule]);
 
 if ([db allSchedule].count>0) {
 NSArray *ScheduleArray = [db allSchedule];
 
 for (NSDictionary *dic in ScheduleArray)
 {
 ScheduleModel *model =(ScheduleModel*)dic;
 //            NSLog(@"dic.title = %@",model.title);
 
 //标题
 NSString *title = [NSString stringWithFormat:@"%@",model.title];
 
 NSString *begintime = [NSString stringWithFormat:@"%@",model.begin_time];
 
 NSTimeInterval timeInterval = [begintime integerValue];
 
 NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
 
 //日期
 NSDate *now = date2;
 
 NSCalendar *calendar = [NSCalendar currentCalendar];
 NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
 NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
 
 NSInteger year = [dateComponent year];
 NSInteger month = [dateComponent month];
 NSInteger day = [dateComponent day];
 //            NSInteger hour = [dateComponent hour];
 //            NSInteger minute = [dateComponent minute];
 //            NSInteger second = [dateComponent second];
 
 //添加时间当天0点时间
 NSString *dangd = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00",(long)year,(long)month,(long)day];
 
 //添加时间当天0点时间时间戳
 long dangdx = [self useTime:dangd];
 long dangdx2 = dangdx+86400000;
 
 NSString *sql = [NSString stringWithFormat:@"select * from table where id between %ld and %ld order by id ASC",dangdx,dangdx2];
 
 NSLog(@"dangd = %ld",dangdx);
 
 NSDate *data = [NSDate dateWithDay:day month:month year:year];
 
 //事件、数据源
 CKCalendarEvent *Kit = [CKCalendarEvent eventWithTitle:title andDate:data andInfo:nil];
 self.data[data] = @[Kit];
 }
 
 }
 
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
