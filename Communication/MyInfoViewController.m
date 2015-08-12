//
//  MyInfoViewController.m
//  Communication
//
//  Created by helloworld on 15/7/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "MyInfoViewController.h"
#import "PublicAction.h"
#import "CalendarViewController.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MyInfoViewController ()

@end
/**
 test
 */
@implementation MyInfoViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 25)];
        field.text=@"通信助手";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    //self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    tableview.dataSource=self;
    tableview.delegate=self;
    tableview.tableFooterView=[[UIView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    [PublicAction tableViewCenter:tableview];

    NSString * path=[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    tableData=[NSDictionary dictionaryWithContentsOfFile:path];
    sections=[tableData.allKeys sortedArrayUsingSelector:@selector(compare:)];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * str=[sections objectAtIndex:section];
    NSArray * arr=[tableData objectForKey:str];
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Cell = @"cell";
    UITableViewCell * tableCell =[tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell==nil) {
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    
    NSString * strKey=[sections objectAtIndex:indexPath.section];
    NSArray * arr=[tableData objectForKey:strKey];
    NSString * name=arr[indexPath.row];
    
    //
    if (indexPath.section==0)
    {
        
        //tableCell.imageView.backgroundColor=[UIColor redColor];
        /*tableCell.imageView.image=[UIImage imageNamed:@"未选1.png"];
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        lable.text=@"张";
        [tableCell.imageView addSubview:lable];*/
        tableCell.imageView.image=[UIImage imageNamed:@"设置.png"];
        tableCell.textLabel.text=name;
        tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        tableCell.imageView.image=[UIImage imageNamed:[name stringByAppendingFormat:@".png"]];
        tableCell.textLabel.text = name;
    }
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if (indexPath.row==1)
        {
            CalendarViewController * calen=[[CalendarViewController alloc]init];
            [self.navigationController pushViewController:calen animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
