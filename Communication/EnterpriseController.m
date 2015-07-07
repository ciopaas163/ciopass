//
//  EnterpriseController.m
//  Communication
//
//  Created by CIO on 15/2/6.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "EnterpriseController.h"
#import "Personal.h"                 //个人通讯助手
#import "SetupController.h"
#import "OrganizationController.h"   //组织构架
#import "CustomerController.h"       //客户通讯录
#import "Shortmessage.h"            //短信助手
#import "MoreViewController.h"      //更多
#import "MasterViewController.h"    //手机本地通讯录
#import "AFHTTPRequestOperationManager.h"
#import "DatabaseModel.h"
#import "Database.h"     //数据库的类


@interface EnterpriseController ()

<UIAlertViewDelegate>
@end

@implementation EnterpriseController

-(void)viewWillAppear:(BOOL)animated{

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"通讯助手";
    

//    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    //创建一个导航栏
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //创建一个导航栏集合
    _navItem = [[UINavigationItem alloc] initWithTitle:nil];
    [self.view addSubview:_navBar];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //创建一个左边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"] style:UIBarButtonItemStylePlain target:self action:@selector(perFormSetup:)];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navBar.frame.origin.y + _navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 110)];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = YES;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self setExtraCellLineHidden:_tableView];
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
    NSLog(@"Setup:设置");
    SetupController* sevc = [[SetupController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sevc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma  UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0;
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
    if (indexPath.section==0) {

        imageNumber.image = [UIImage imageNamed:@"organization@2x.png"];
        textLabel.text = @"组织构架";

    }
    else if (indexPath.section==1){
        imageNumber.image = [UIImage imageNamed:@"Customer@2x.png"];
        textLabel.text = @"客户通讯录";

    }  else if (indexPath.section==2){

        imageNumber.image = [UIImage imageNamed:@"personal-contact@2x.png"];
        textLabel.text = @"个人通讯录";

    }  else if (indexPath.section==3){

        imageNumber.image = [UIImage imageNamed:@"mobile-contact@2x.png"];
        textLabel.text = @"手机通讯录";

    }  else if (indexPath.section==4){

        imageNumber.image = [UIImage imageNamed:@"message-helper@2x.png"];
        textLabel.text = @"短信助手";

    } else if (indexPath.section==5){

        imageNumber.image = [UIImage imageNamed:@"more@2x.png"];

         textLabel.text = @"更多";

    }
    [tableCell.contentView addSubview:imageNumber];
    [tableCell.contentView addSubview:textLabel];
    tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return tableCell;
}
#pragma mark 【 组织构架  客户通讯录 个人通讯录 手机通讯录 短信助手 更多 】
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        NSLog(@"组织构架");
        
        OrganizationController* organ = [[OrganizationController alloc] init];
         organ.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰

        [self.navigationController pushViewController:organ animated:YES];
        
    }else if (indexPath.section == 1){
        NSLog(@"客户通讯录");
        
        CustomerController* custome = [[CustomerController alloc] init];
        custome.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰
        
        [self.navigationController pushViewController:custome animated:YES ];
        
    }else if (indexPath.section == 2) {
        NSLog(@"个人通讯录");
        
        Personal* personal = [[Personal alloc] init];

        [self PersonalURL];

        [self.navigationController pushViewController:personal animated:YES];


    }else if (indexPath.section == 3){
        NSLog(@"手机通讯录");

        MasterViewController* master = [[MasterViewController alloc] init];
        master.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰
        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        picker.newPersonViewDelegate = self;
        [self.navigationController pushViewController:master animated:YES];

    }else if (indexPath.section == 4){

        NSLog(@"短信助手");

//        Shortmessage* message = [[Shortmessage alloc] init];
//        [self.navigationController pushViewController:message animated:YES];

        [self alertView];

    }else if (indexPath.section == 5){
        NSLog(@"更多");

//        MoreViewController * more = [[MoreViewController alloc]init];
//        [self.navigationController pushViewController:more animated:YES];

        [self alertView];

    }
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
#pragma mark  === [网络请求  -- 组织构架]
-(void)enterpriseURL{
//   管理器
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *_id = [defaults objectForKey:@"nid"];
    NSString* eid = [defaults objectForKey:@"eid"];
    NSString* verify = [defaults objectForKey:@"verify"];
    NSString* auchCode = [defaults objectForKey:@"auchCode"];
    NSString* timestamp = [defaults objectForKey:@"timestamp"];

    
    NSLog(@"%@,%@,%@,%@,%@",_id,eid,verify,auchCode,timestamp);
    //    设置参数
    NSDictionary* dict = @{@"id":_id,@"verify":verify,@"eid":eid,@"auchCode":auchCode,@"timestamp":timestamp};
    
//    请求
    [manager GET:@"http://open.ciopaas.com/Admin/Info/get_EnterpriseArchitecture?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"get:%@",operation.responseString);
        NSError* error = nil ;
        NSDictionary* dicti = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
        if (error) {

        }else{
            
            NSMutableArray *array = [NSMutableArray array];
            NSArray *organiza = [dicti objectForKey:@"OrganizationalStructure"];
            for (NSDictionary *content in organiza) {
                DatabaseModel *model = [[DatabaseModel alloc] init];
                model._id = [content objectForKey:@"id"];
                model.pid = [content objectForKey:@"pid"];
                model.departmentname = [content objectForKey:@"departmentname"];
                model.eid = [content objectForKey:@"eid"];
                model.ctime = [content objectForKey:@"ctime"];
                
                Database *db = [Database sharDatabase];
                
                NSString*searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Enterprise",@"_id",model._id];//从ID_Enterprise表里面读取_id列的值为model._id的这一行的数据
                
                BOOL isExists = NO;
                if ([db.datadb open]) {
                    
                    FMResultSet *result = [db.datadb executeQuery:searchSql];//查询searchSql里的model._id;
                    
                    while ([result next]) { //遍历这个表里的每一列
                        NSString *_id = [result stringForColumn:@"_id"]; //查询到列里的："_id"
                        
                        if ([_id isEqualToString:model._id]) {
                            
                            isExists = YES;
                            
                            break;
                        }
                    }
                    
                    [db.datadb close]; //关闭表
                }
//                NSLog(@"result %d",isExists);
                if (isExists) {//判断存在  此时isExists 为YES   【存在 就更新】
                    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@',%@ = '%@', %@ ='%@',%@ = '%@' WHERE %@ = '%@'",@"ID_Enterprise",@"pid",model.pid,@"departmentname",model.departmentname,@"eid",model.eid,@"ctime",model.ctime,@"_id",model._id];
                    if ([db.datadb open]) {//打开表
                        
                        [db.datadb executeUpdate:updateSql];//更新updateSql表的内容

                        //        通过fmdb读取.db文件中得数据
//                        NSMutableArray*  _idArrayLength=[db stringForQuery:@"SELECT departmentname FROM ID_name",model.departmentname];

                        [db.datadb close];
                    }
                }else{//否则就添加数据
                    NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id, pid, departmentname,eid,  ctime) VALUES ('%@','%@','%@','%@','%@')",@"ID_Enterprise",model._id,model.pid,model.departmentname,model.eid,model.ctime];
                    [db saveSql:inserSQL]; //把数据保存到数据库的@"ID_Enterprise"表里
                    //        通过fmdb读取.db文件中得数据
//                    NSMutableArray*  _idArrayLength=[db stringForQuery:@"SELECT departmentname FROM ID_Enterprise",model.departmentname];


                }
                _arrarNSstr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Enterprise",@"departmentname",model.departmentname];
                NSLog(@"^^departmentname^^:%@",_arrarNSstr);

            }
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"~~~~get:%@",error);
        
    }];

#pragma mark ====【 保存到本地数据库   == 组织架构 】
    
    Database * db = [Database sharDatabase];
    NSLog(@"数据DB:%@",db);
//    设置表名：
    NSString* TableName = @"ID_Enterprise";
//    设置表名的标题
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id text, pid TEXT, departmentname TEXT, eid TEXT, ctime TEXT)",TableName];

//    创建表的方法   【创建数据库的操作】
    [db creatDatabase:create];
    
//    读数据库的表
    NSString *readSql = [NSString stringWithFormat:@"SELECT * FROM %@",TableName];

    FMResultSet* resuet = [db readSql:readSql];
    while ([resuet next]) {
        /*
        NSLog(@"~~@@~~:%@\n",[resuet stringForColumn:@"_id"]);
        NSLog(@"~~@@~~:%@\n",[resuet stringForColumn:@"pid"]);
        NSLog(@"~~@@~~:%@\n",[resuet stringForColumn:@"departmentname"]);
        NSLog(@"~~@@~~:%@\n",[resuet stringForColumn:@"eid"]);
        NSLog(@"~~@@~~:%@\n",[resuet stringForColumn:@"ctime"]);
   */
         }
    
//    关闭表
    [db.datadb close];
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
    NSLog(@"~~~个人通讯录:_id:%@,verify:%@,usertype:%@,timestamp:%@",_id,verify,usertype,timestamp);
//    设置参数
    NSDictionary* dicts2 = @{@"id":_id,@"verify":verify,@"usertype":usertype,@"timestamp":timestamp};
//   发送请求
    [manager GET:@"http://open.ciopaas.com/Admin/Info/get_personal_group?" parameters:dicts2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"~~个人信息get:%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"~~~GET:%@",error);
    }];

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
