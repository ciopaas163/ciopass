//
//  CalendarcomViewController.m
//  Communications
//
//  Created by helloworld on 15/1/29.
//  Copyright (c) 2015年 helloworld. All rights reserved.
//

#import "CalendarcomViewController.h"
#import "CalendarcomCell.h"

#import "Database.h"  //数据库获取数据
#import "FMDatabase.h"

#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
@interface CalendarcomViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableData *_data;
}
@end

@implementation CalendarcomViewController

-(void)viewWillAppear:(BOOL)animated
{
    Database *db = [Database sharDatabase];
    
    
    _dataArray = [[NSMutableArray alloc] init];
    

    
    NSString *sql = [NSString stringWithFormat:@"select * from Calendar where Modular ='3' order by time desc"];
    FMResultSet *set =(FMResultSet *)[db searchCalendar:sql];
    
    while ([set next])
    {
        ScheduleModel *Schedule = [[ScheduleModel alloc] init];
        
        //从数据库取数据
        
        Schedule.title = [set stringForColumn:@"title"];
        Schedule.content = [set stringForColumn:@"State"];
        Schedule.loginID = [set stringForColumn:@"jishi"];
        
        NSDate *dat =[self timeuse:[set stringForColumn:@"time"]];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm"];
        
        NSString *str=[dateFormatter stringFromDate :dat];
        
        Schedule.mid = str;
        
        [_dataArray addObject:Schedule];
    }
    
    [_tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
  
    

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KSCREENWIDTH, KSCRENHEIGHT-94) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}

-(NSDate *)timeuse:(NSString *)time
{
    int timeInterval2 = [time intValue];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval2];  //时间戳转时间
    
    return date2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cell";
    CalendarcomCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:IDCell];
    if (cell==nil) {
        cell =  (CalendarcomCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"CalendarcomCell" owner:self options:nil]  lastObject];
    }
    ScheduleModel *Schedule =(ScheduleModel *)_dataArray[indexPath.row];
    if ([Schedule.loginID isEqualToString:@"记事"])
    {
        cell.ImgView.image = [UIImage imageNamed:@"记事.png"];
    }
    else
    {
        cell.ImgView.image = [UIImage imageNamed:@"提醒.png"];

    }

    cell.titleLable.text = Schedule.title;
    cell.stateLable.text = Schedule.content;
    cell.timeLable.text = Schedule.mid;
    
    if ([Schedule.content isEqualToString:@"删除"]) {
        cell.stateLable.textColor = [UIColor redColor];
    }
    cell.JiLable.text = Schedule.loginID;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
