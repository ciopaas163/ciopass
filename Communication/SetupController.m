//
//  SetupController.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "SetupController.h"
#import "PublicViewController.h"
#import "MailliTableViewCell.h"
#import "DataController.h"
#import "ViewController.h"


#import "DataController.h"
#import "AlterpasswordViewController.h"
#import "HelpViewController.h"
#import "CommunicationSetupViewController.h"
#import "AboutViewController.h"

#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface SetupController ()
{
    QRadioButton *rb1;
}
@end

@implementation SetupController

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"我的设置";


    //    UIBarButtonItemStyleBordered
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickButton:)];
    leftButton.tag = 40;
    [self.navigationItem setLeftBarButtonItem:leftButton];


//    [self usenavigationbarView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = YES;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 9;
    [self.view addSubview:_tableView];


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
    [titleButton setText:@"我的设置"];
    [navigationbarView addSubview:titleButton];

    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:backButton];

}

#pragma mark 按钮
-(void)clickButton:(UIBarButtonItem*)leftbutton{
    NSLog(@"返回");

    [self dismissViewControllerAnimated:YES completion:nil];


}

-(void)buttonSignout:(UIButton*)signout{
    NSLog(@"退出成功");
    ViewController* vcr = [[ViewController alloc]init];
    [self presentViewController:vcr animated:YES completion:nil];
}

#pragma  UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    else if (section==3)
    {
        return 1;
    }
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * Cell=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    if (indexPath.section==0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"我的资料";

        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"修改密码";
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"帮助";
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"通讯设置";
        }
        else
        {
            cell.textLabel.text = @"是否显示农历";
            //            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 20.0f)];
            //            switchView.on = YES;
            //            cell.accessoryView = switchView;
            //            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];

            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 26.0f)];
            [but setImage:[UIImage imageNamed:@"开"] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:@"关"] forState:UIControlStateSelected];
            [but addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = but;
        }
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"显号设置";

        }
        else if (indexPath.row == 1)
        {
            rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
            QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
            [rb1 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
            [rb1 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
            [rb2 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
            [rb2 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];

            [rb1 setChecked:YES];
            rb1.frame = CGRectMake(13,10,20, 20);

            rb2.frame = CGRectMake(80,10,20, 20);

            CGFloat rb1X = rb1.frame.origin.x+20;
            CGFloat rb2X = rb2.frame.origin.x+20;

            UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(rb1X,8,50, 24)];
            qianLable.font = [UIFont systemFontOfSize:14];
            qianLable.textColor = [UIColor blackColor];

            UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(rb2X,8,50, 24)];
            qianLabletwo.font = [UIFont systemFontOfSize:14];
            qianLabletwo.textColor = [UIColor blackColor];

            qianLable.text = @"手机";
            qianLabletwo.text = @"固话";
            [cell.contentView addSubview:rb1];
            [cell.contentView addSubview:rb2];
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:qianLabletwo];
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"关于";
        }
    }
    else
    {
        UIButton* btnSignout = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSignout.frame = CGRectMake(20,0, self.view.frame.size.width - 20*2, 40);
        [btnSignout setTitle:@"退出登录" forState:UIControlStateNormal];
        btnSignout.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:88.0/255.0 blue:83.0/255.0 alpha:1];
        btnSignout.layer.cornerRadius = 8;
        btnSignout.tag = 41;
        [btnSignout addTarget:self action:@selector(buttonSignout:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnSignout];
        cell.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];

    }



    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSLog(@" 我的资料");
            DataController* data = [[DataController alloc] init];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:data];
            [self presentViewController:nav animated:YES completion:nil];

        }
        else if (indexPath.row == 1)
        {
            NSLog(@"修改密码");
            AlterpasswordViewController *alterpassword = [[AlterpasswordViewController alloc]init];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:alterpassword];
            [self presentViewController:nav animated:YES completion:nil];

        }
        else if (indexPath.row == 2)
        {
            NSLog(@" 帮助");
            HelpViewController *help = [[HelpViewController alloc]init];
            ;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:help];
            [self presentViewController:nav animated:YES completion:nil];

        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            NSLog(@" 通讯设置");
            CommunicationSetupViewController *communication = [[CommunicationSetupViewController alloc]init];
            ;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:communication];
            [self presentViewController:nav animated:YES completion:nil];

        }
        else if (indexPath.row == 1)
        {
            NSLog(@" 是否显示农历");

        }
        else if (indexPath.row == 2)
        {
            NSLog(@" 关于通讯助手");
            AboutViewController *about = [[AboutViewController alloc]init];
            ;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:about];
            [self presentViewController:nav animated:YES completion:nil];
        }

    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 2)
        {
            NSLog(@" 关于通讯助手");
            AboutViewController *about = [[AboutViewController alloc]init];
            ;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:about];
            [self presentViewController:nav animated:YES completion:nil];
        }

    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 20;
    }
    return 10;
}

#pragma mark  隐藏分割线
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

-(void)switchAction:(UIButton *)sender
{
    //    UISwitch *tmpSwitch = (UISwitch *)sender;
    //    if (tmpSwitch.on) {
    //        tmpSwitch.ti
    //    }
    sender.selected = !sender.selected;
}

#pragma mark 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"1111did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
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
