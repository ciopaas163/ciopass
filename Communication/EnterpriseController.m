//
//  EnterpriseController.m
//  Communication
//
//  Created by CIO on 15/2/6.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "EnterpriseController.h"
#import "PersonalViewController.h"                 //个人通讯助手
#import "SetupController.h"
#import "OrganizationController.h"   //组织构架
#import "CustomerController.h"       //客户通讯录
#import "Shortmessage.h"            //短信助手
#import "MoreViewController.h"      //更多
#import "MasterViewController.h"    //手机本地通讯录
#import "AFHTTPRequestOperationManager.h"
#import "DatabaseModel.h"
#import "Database.h"     //数据库的类
#import "PublicAction.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface EnterpriseController ()

<UIAlertViewDelegate>
@end

@implementation EnterpriseController

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
        //UIImage *image=[UIImage imageNamed:@"com_ttshrk_view_scroll_picker_bar.png"];
        //[self.tabBarController.tabBar setBackgroundImage:image];
        //self.tabBarController.tabBar.opaque = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"通讯助手";
    
    //创建一个导航栏
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //创建一个导航栏集合
    _navItem = [[UINavigationItem alloc] initWithTitle:nil];
    [self.view addSubview:_navBar];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navBar.frame.origin.y + _navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 110)];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = YES;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self setExtraCellLineHidden:_tableView];
    
    [PublicAction tableViewCenter:_tableView];
    
    sectionDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    NSMutableArray * dict1;
    NSMutableArray * dict2;
    
    NSUserDefaults * users=[NSUserDefaults standardUserDefaults];
    NSString * usertype=[users objectForKey:@"userType"];
    if ([usertype isEqual:@"3"])
    {
        
        dict1=[[NSMutableArray alloc]initWithObjects:[NSArray arrayWithObjects:@"个人通讯录",@"personal-contact@2x.png",@"3", nil], nil];
        dict2=[[NSMutableArray alloc]initWithObjects:[NSArray arrayWithObjects:@"手机通讯录",@"mobile-contact@2x.png",@"4", nil], nil];
        //[NSArray arrayWithObjects:@"短信助手",@"message-helper@2x.png",@"5", nil]
    }else
    {
        
        dict1=[[NSMutableArray alloc]initWithObjects:[NSArray arrayWithObjects:@"公司团队",@"organization@2x.png",@"1", nil],[NSArray arrayWithObjects:@"客户通讯录",@"Customer@2x.png",@"2", nil],[NSArray arrayWithObjects:@"个人通讯录",@"personal-contact@2x.png",@"3", nil], nil];
        dict2=[[NSMutableArray alloc]initWithObjects:[NSArray arrayWithObjects:@"手机通讯录",@"mobile-contact@2x.png",@"4", nil], nil];
        
    }
    
    if (sectionDic)
    {
        [sectionDic setValue:dict1 forKey:@"aFirst"];
        [sectionDic setValue:dict2 forKey:@"bSecond"];
    }
}
#pragma mark  清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];

}


#pragma mark  --- 设置按钮
-(void)perFormSetup:(UISegmentedControl*)Setup{
    SetupController* sevc = [[SetupController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sevc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma  UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr=[sectionDic objectForKey: [[[sectionDic allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:section]];
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionDic.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Cell = @"cell";
    UITableViewCell * tableCell =[tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell==nil) {
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    UIImageView * imageNumber = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 65, 40)];
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageNumber.frame.origin.x + imageNumber.frame.size.width, imageNumber.frame.origin.y, 100, imageNumber.frame.size.height)];
    NSArray * keys=[[sectionDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSArray * tableData=[sectionDic objectForKey:keys[indexPath.section]];
    NSArray * data=[tableData objectAtIndex:indexPath.row];
    imageNumber.image=[UIImage imageNamed:[data objectAtIndex:1]];
    textLabel.text=[data objectAtIndex:0];
    
    
    [tableCell.contentView addSubview:imageNumber];
    [tableCell.contentView addSubview:textLabel];
    tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return tableCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma mark 【 组织构架  客户通讯录 个人通讯录 手机通讯录 短信助手 更多 】
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray * keys=[[sectionDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSArray * tableData=[sectionDic objectForKey:keys[indexPath.section]];
    NSArray * data=[tableData objectAtIndex:indexPath.row];
    NSInteger mark=[[data objectAtIndex:2] integerValue];
    if (mark == 1) {
        OrganizationController* organ = [[OrganizationController alloc] init];
         organ.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰

        [self.navigationController pushViewController:organ animated:YES];
        
    }else if (mark == 2){
        
        CustomerController* custome = [[CustomerController alloc] init];
        custome.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰
        
        [self.navigationController pushViewController:custome animated:YES ];
        
    }else if (mark == 3) {
        
        PersonalViewController* personal = [[PersonalViewController alloc] init];
        personal.hidesBottomBarWhenPushed=YES;
        //[self PersonalURL];

        [self.navigationController pushViewController:personal animated:YES];


    }else if (mark == 4){

        MasterViewController* master = [[MasterViewController alloc] init];
        master.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰
        //ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        //picker.newPersonViewDelegate = self;
        [self.navigationController pushViewController:master animated:YES];

    }else if (mark == 5){

//        Shortmessage* message = [[Shortmessage alloc] init];
//        [self.navigationController pushViewController:message animated:YES];

        [self alertView];

    }else if (mark == 6){

//        MoreViewController * more = [[MoreViewController alloc]init];
//        [self.navigationController pushViewController:more animated:YES];

        [self alertView];

    }
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark 获取通讯录
#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

-(void)showPeoplePickerController
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];


    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark ---- alertView { 提示框  【 未完成】}
-(void)alertView{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"该功能还未完成" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    // 0.8秒钟后进行消失
    [self performSelector:@selector(timerAlert:) withObject:alert afterDelay:0.8];
    [alert show];
}
#pragma mark ==[// UIAlertView【2秒钟后自动移除】 移除方法]
-(void)timerAlert:(UIAlertView*)alert{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma mark  === [网络请求  -- 个人通讯录]
-(void)PersonalURL{
    //管理器
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    

    NSUserDefaults* defaulte = [NSUserDefaults standardUserDefaults];
//    取出保存的数据
    NSString* _id = [defaulte objectForKey:@"nid"];
    NSString* verify = [defaulte objectForKey:@"verify"];
    NSString* usertype = [defaulte objectForKey:@"usertype"];
    NSString* timestamp = [defaulte objectForKey:@"timestamp"];
//    设置参数
    NSDictionary* dicts2 = @{@"id":_id,@"verify":verify,@"usertype":usertype,@"timestamp":timestamp};
//   发送请求
    [manager GET:@"http://open.ciopaas.com/Admin/Info/get_personal_group?" parameters:dicts2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
