//
//  ScheduleViewController.m
//  Communication
//
//  Created by helloworld on 15/2/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "ScheduleViewController.h"
#import "UUDatePicker.h"
#import "Header.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface ScheduleViewController ()<UITableViewDataSource,UITableViewDelegate,UUDatePickerDelegate>
{
    UITableView*  _tableView;
    NSMutableArray *_titleArray;
    NSMutableArray *_detailArray;
}
@property (nonatomic,strong)UIView *navigationbarView;
@end

@implementation ScheduleViewController

#pragma mark - 设置导航栏
- (void)setNavigationBar {

    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    field.text = @"添加日程";
    field.textColor = [UIColor whiteColor];
    field.textAlignment = NSTextAlignmentCenter;
    field.font = [UIFont boldSystemFontOfSize:17];
    field.enabled = NO;
    self.navigationItem.titleView = field;

    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btn;
    
}
-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBar];

     _titleArray = [NSMutableArray arrayWithObjects:@"用户类型",@"任务类型",@"开始时间",@"结束时间",@"提醒时间",@"参与者", @"目标客户",  nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = NO;
    _tableView.scrollEnabled = NO;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 9;
    [_tableView setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:_tableView];

    
}

#pragma mark - 导航栏返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDCell];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    QRadioButton *rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    [rb1 setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
    [rb1 setImage:[UIImage imageNamed:@"选中_2.png"] forState:UIControlStateSelected];
    [rb2 setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
    [rb2 setImage:[UIImage imageNamed:@"选中_2.png"] forState:UIControlStateSelected];
    [rb1 setChecked:YES];
    rb1.frame = CGRectMake(80,5,20, 20);
    rb2.frame = CGRectMake(150,5,20, 20);
    
    CGFloat rb1X = rb1.frame.origin.x+20;
    CGFloat rb2X = rb2.frame.origin.x+20;
    
    UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(rb1X,3,50, 24)];
    qianLable.font = [UIFont systemFontOfSize:13];
    qianLable.textColor = [UIColor blackColor];
    
    UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(rb2X,3,50, 24)];
    qianLabletwo.font = [UIFont systemFontOfSize:13];
    qianLabletwo.textColor = [UIColor blackColor];

    switch (indexPath.row) {
        case 0:
            qianLable.text = @"企业用户";
            qianLabletwo.text = @"个人用户";
            rb1.frame = CGRectMake(80,5,20, 20);
            rb2.frame = CGRectMake(180,5,20, 20);
            CGFloat rb1X = rb1.frame.origin.x+20;
            CGFloat rb2X = rb2.frame.origin.x+20;
            qianLable.frame =CGRectMake(rb1X,3,60, 24);
            qianLabletwo.frame =CGRectMake(rb2X,3,60, 24);
            [cell.contentView addSubview:rb1];
            [cell.contentView addSubview:rb2];
            
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:qianLabletwo];
            cell.userInteractionEnabled = NO;
            break;
        case 1:
            qianLable.text = @"提醒";
            qianLabletwo.text = @"记事";
            [rb1 setChecked:YES];
            [cell.contentView addSubview:rb1];
            [cell.contentView addSubview:rb2];
            
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:qianLabletwo];
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    NSLog(@"index = %ld",(long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, (KSCREENHEIGHT-240-64)/5*2)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat headerViewY = CGRectGetMidY(headerView.bounds);
    NSLog(@"yy = %f ",headerViewY);
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(12,5, 40, 30)];
    nameLable.text = @"标题";

    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLable];
    
    UITextField *biaoTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, KSCREENWIDTH-60, 30)];
    [biaoTextfiled setBorderStyle:UITextBorderStyleRoundedRect];
    [headerView addSubview:biaoTextfiled];
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(12,40, 40, 30)];
    textLable.text = @"内容";

    textLable.font = [UIFont systemFontOfSize:15];
    textLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:textLable];
    
    UITextView *contentView = [[UITextView alloc]initWithFrame:CGRectMake(55,40, KSCREENWIDTH-60, (KSCREENHEIGHT-240-64)/5*2-45)];
    contentView.layer.borderWidth = 1.0f;
    contentView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]CGColor];
    
    [headerView addSubview:contentView];
    return headerView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, (KSCREENHEIGHT-240-64)/5*3)];
    footerView.backgroundColor = [UIColor whiteColor];
    NSArray *buttonArr = [NSArray arrayWithObjects:@"确认",@"取消",nil];
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*KSCREENWIDTH/4 + 40 + i*(40 + 40),10, KSCREENWIDTH/4, 40)];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = [COLOR(204, 223, 230, 1)CGColor];
//        button.layer.cornerRadius = 5;
        [footerView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (KSCREENHEIGHT-240-64)/5*2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (KSCREENHEIGHT-240-64)/5*3;
}
-(void)backButtonClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 确认、取消 
-(void)buttonClick:(UIButton *)sender
{
    NSLog(@"fsf");
}

#pragma mark 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
}
@end
