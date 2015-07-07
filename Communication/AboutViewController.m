//
//  AboutViewController.m
//  Communication
//
//  Created by helloworld on 15/2/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "AboutViewController.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView*  _tableView;
    NSMutableArray *_titleArray;
    NSMutableArray *_detailArray;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    
    _titleArray = [NSMutableArray arrayWithObjects:@"检查更新",@"功能介绍",@"服务热线",@"用户协议", nil];
    _detailArray = [NSMutableArray arrayWithObjects:@"Copyright@1993-2015 CIO All Rights Reserved",@"深圳市西艾欧科技有限公司 版权所有",@"www.ciopaas.com", nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self usenavigationbarView];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = YES;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 9;
    [_tableView setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:_tableView];
}
#pragma mark 返回
-(void)leftButtonClick:(UIButton*)backButton{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 导航
-(void)usenavigationbarView
{
    [self.navigationController.navigationBar setHidden:YES];
    UIView * navigationbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KSCREENWIDTH, 44)];
    navigationbarView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:169.0/255.0 blue:224.0/255.0 alpha:1];
    [self.view addSubview:navigationbarView];
    
    UILabel *titleButton = [[UILabel alloc]initWithFrame:CGRectMake(KSCREENWIDTH/2-KSCREENWIDTH/6,4,KSCREENWIDTH/3, 36)];
    //    timeButton.backgroundColor = [UIColor redColor];
    titleButton.textAlignment = NSTextAlignmentCenter;
    titleButton.textColor = [UIColor whiteColor];
    [titleButton setText:@"关于"];
    [navigationbarView addSubview:titleButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:backButton];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row==0) {
        cell.detailTextLabel.text = @"V1.0";
       
    }
    else if (indexPath.row==2)
    {
        cell.detailTextLabel.text = @"4007779908";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, (KSCREENHEIGHT-160-64)/2)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(KSCREENWIDTH/2 - 80/2, (KSCREENHEIGHT-160-64)/4-40, 80, 80)];
    imgLogo.image = [UIImage imageNamed:@"LOGO.png"];
    [headerView addSubview:imgLogo];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(KSCREENWIDTH/2 - 100/2, (KSCREENHEIGHT-160-64)/4+50, 100, 30)];
    nameLable.text = @"通信助手";
    nameLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLable];

  
    return headerView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, (KSCREENHEIGHT-160-64)/2)];
    footerView.backgroundColor = [UIColor whiteColor];
    for (NSInteger i =0; i<3; i++) {
        UILabel *detailLable = [[UILabel alloc]initWithFrame:CGRectMake(0,(KSCREENHEIGHT-160-64)/6+i*30, KSCREENWIDTH, 30)];
        detailLable.text = _detailArray[i];
        detailLable.font = [UIFont systemFontOfSize:14];
        detailLable.alpha = 0.5;
        detailLable.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:detailLable];
        
    }
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (KSCREENHEIGHT-160-64)/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (KSCREENHEIGHT-160-64)/2;
}

#pragma mark 按钮
-(void)clickButton:(UIBarButtonItem*)leftbutton
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
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

/*
 
 
 */

@end
