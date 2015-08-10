//
//  PersonalViewController.m
//  Communication
//
//  Created by helloworld on 15/7/23.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PersonalViewController.h"
#import "MethodController.h"
#import "PersonCell.h"
#import "Header.h"
#import "PersonMarkModel.h"
#import "PublicAction.h"
#import "UIButton+UIButtonImageWithLable.h"
#import "CustomerCell.h"
#import "PersonDetailViewController.h"
#import "FMDatabase.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "newUsercontact.h"
@interface PersonalViewController ()
#define PERSONINFO  @"personInfo"
#define TAGS        @"tags"
@end

@implementation PersonalViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
        UILabel * field=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"个人通讯录";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        self.navigationItem.titleView=field;
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(returnButton:)];
        leftButton.tintColor=[UIColor whiteColor];
        [self.navigationItem setLeftBarButtonItem:leftButton];
        
        UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_btn_white.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(addPersonInfo:)];
        right.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=right;
        //[self deleteGroup];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    _showData=[NSMutableDictionary dictionary];
    _dataArray=[NSMutableArray array];
    _personInfo=[NSMutableDictionary dictionary];
    //[self getLocalInfo];
    [self loadData];
    [self personInfoTable];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.status isEqualToString:@"1"]||[self.status isEqualToString:@"0"]) {
        [_dataArray removeAllObjects];
        [_personInfo removeAllObjects];
        [_showData removeAllObjects];
        [self loadData];
    }
}

#pragma mark 网络或本地数据请求

-(void)loadData
{
    [self loadMarkLocalData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadStaffLocalData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [_personTable reloadData];
        });
    });
}

-(void)loadMarkLocalData
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    
    NSString* TableName = @"ID_Usergroups";
    //    创建表的方法   【创建数据库的操作】
    BOOL b=[db open];
    NSString * querySql=[NSString stringWithFormat:@"select * from %@",TableName];
    FMResultSet * result=nil;
    if ([db open])
        result=[db executeQuery:querySql];
    if (result==nil)
    {
        [self getMarkWithUrl];
        return;
    }
    while ([result next]) {
        PersonMarkModel *model = [[PersonMarkModel alloc] init];
        model._id = [result stringForColumn:@"_id"];
        model.groupname = [result stringForColumn:@"groupname"];
        model.ctime = [result stringForColumn:@"ctime"];
        model.status=@"0";
        [_dataArray addObject:model];
    }
    CusModel *model = [[CusModel alloc] init];
    model._id=@"-1";
    [_dataArray addObject:model];
}

-(void)loadStaffLocalData
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名
    NSString* tableName = @"ID_Usercontact";
    //    创建表的方法【创建数据库里的表】
    if (![db open]) {
        return;
    }
    NSString * querySql=[NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet * result=nil;
    if ([db open])
        result=[db executeQuery:querySql];
    if (result==nil)
    {
        [self queryContactWithUrl];
    }
    while ([result next]) {
        PersonInfoModel* model = [[PersonInfoModel alloc]init];
        model.sysid=[result stringForColumn:@"sysid"];
        model.name = [result stringForColumn:@"name"];
        model.fax = [result stringForColumn:@"fax"];
        model._id = [result stringForColumn:@"_id"];
        model.department = [result stringForColumn:@"department"];
        model.job = [result stringForColumn:@"job"];
        model.mobilePhone = [result stringForColumn:@"mobilePhone"];
        model.telephone1 = [result stringForColumn:@"telephone1"];
        model.telephone2 = [result stringForColumn:@"telephone2"];
        model.company = [result stringForColumn:@"company"];
        model.email = [result stringForColumn:@"email"];
        model.cid = [result stringForColumn:@"cid"];
        model.ctime = [result stringForColumn:@"ctime"];
        model.industry = [result stringForColumn:@"industry"];
        model.internet = [result stringForColumn:@"internet"];
        model.remark = [result stringForColumn:@"remark"];
        model.birthday = [result stringForColumn:@"birthday"];
        model.cus_type=[result intForColumn:@"cus_type"];
        //把取出的model保存到可变数组里
        [self addCustoArray:model];
    }
}

-(void)addCustoArray:(PersonInfoModel*)addModel
{
    if ([addModel.cid isEqual:[NSNull null]]||addModel.cid==nil)
    {
        addModel.cid=@"";
    }
    if ([addModel.cid isEqualToString:@""]||[addModel.cid isEqualToString:@"0"])
    {
        NSMutableArray * arr=[_personInfo objectForKey:@"-1"];
        
        if (arr.count==0)
        {
            [_personInfo setObject:[NSMutableArray arrayWithObject:addModel] forKey:@"-1"];
        }else
        {
            [arr addObject:addModel];
            [_personInfo setObject:arr forKey:@"-1"];
        }
    }else
    {
        if (addModel.cid)
        {
            NSArray * cids=[addModel.cid componentsSeparatedByString:@","];
            for (NSString * str in cids)
            {
                NSMutableArray * arr=[_personInfo objectForKey:str];
                
                if (arr.count==0)
                {
                    [_personInfo setObject:[NSMutableArray arrayWithObject:addModel] forKey:str];
                }else
                {
                    [arr addObject:addModel];
                    [_personInfo setObject:arr forKey:str];
                }
            }
        }
    }
}

-(void)queryContactWithUrl
{
    NSString* _id = [_defaults objectForKey:@"nid"];
    NSString* verify = [_defaults objectForKey:@"verify"];
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/get_personal?id=%@&verify=%@",_id,verify];
    NSURLRequest * request=[NSURLRequest requestWithURL: [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error==NULL)
    {
        NSDictionary * dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray * array=[NSArray arrayWithArray:[dictionary objectForKey:@"PersonalAddressBook"]];
        for (NSDictionary * d in array)
        {
            NSArray * arr=[d allKeys];
            PersonInfoModel *model=[[PersonInfoModel alloc]init];
            for (NSString * s in arr)
            {
                if ([s isEqualToString:@"id"])
                {
                    model._id=[d objectForKey:s];
                }else
                {
                    [model setValue:[d objectForKey:s] forKey:s];
                }
            }
            model.cus_type=0;
            [self addCustoArray:model];
            [self updatePersonLocalData:model];
        }
    }
    
}

-(void)getMarkWithUrl
{
    NSString* _id = [_defaults objectForKey:@"nid"];
    NSString* usertype = [_defaults objectForKey:@"userType"];
    NSString* verify = [_defaults objectForKey:@"verify"];
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/get_personal_group?id=%@&verify=%@& usertype=%@",_id,verify,usertype];
    NSURLRequest * request=[NSURLRequest requestWithURL: [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error==NULL)
    {
        NSDictionary * dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray * array=[NSArray arrayWithArray:[dictionary objectForKey:@"PersonalGroupName"]];
        if (_dataArray==nil)
            _dataArray=[NSMutableArray array];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary * dict=[array objectAtIndex:i];
            PersonMarkModel * model=[[PersonMarkModel alloc]init];
            model._id=[dict objectForKey:@"id"];
            model.groupname=[dict objectForKey: @"groupname"];
            model.ctime=[dict objectForKey:@"ctime"];
            model.status=@"0";
            [_dataArray addObject:model];
            [self updateMarkLocalData:model];
        }
        PersonMarkModel * model=[[PersonMarkModel alloc]init];
        model._id=@"-1";
        [_dataArray insertObject:model atIndex:_dataArray.count];
    }
}

- (void)personInfoTable{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate=self;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [PublicAction clearSearchBarcolor:searchBar];
    [self.view addSubview:searchBar];
    _personTable = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 48 - searchBar.frame.size.height )];
    _personTable.backgroundColor = [UIColor clearColor];
    _personTable.bounces = YES;
    _personTable.dataSource = self;
    _personTable.delegate = self;
    _personTable.contentSize = CGSizeMake(0, _personTable.bounds.size.height + 1);
    [PublicAction tableViewCenter:_personTable];
    [_personTable setTableFooterView:[UIView new]];
    [self.view addSubview:_personTable];
}

#pragma mark 按钮
-(void)returnButton:(UIBarButtonItem*)leftbutton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)addPersonInfo:(UIBarButtonItem*)rightbutton
{
    UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"添加" message:nil
                                                   delegate:self cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"添加联系人", @"添加分组",nil];
    
    alert.tag = 100;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == 100) {
            if (buttonIndex == 1){
                newUsercontact* contact = [[newUsercontact alloc]init];
                contact.dataArray=_dataArray;
                [self.navigationController pushViewController:contact animated:YES];
            }else if (buttonIndex == 2){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"添加标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确认", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 101;
                [alert show];
            }
        }
        
        if (alertView.tag == 101) {
            UITextField * field = (UITextField *)[alertView textFieldAtIndex:0];
            NSString * mark=field.text;
            PersonMarkModel * model=[[PersonMarkModel alloc]init];
            model.groupname=mark;
            PersonMarkModel * group=[self insertUserGroupInLocal:model];
            if (group)
            {
                [self insertUserGroupWithUrl:model];
            }
        }
    }
}

-(void)deleteGroup
{
    NSArray * array=[NSArray arrayWithObjects:@"1024",@"1023",@"1022",@"1021", nil];
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    for (int i=0; i<array.count; i++) {
        NSDictionary * telDict=[NSDictionary dictionaryWithObjectsAndKeys:array[i],@"id", nil];
        
        NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
        
        NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/delete_personal_groups?id=%@&verify=%@&groups=%@",_ids,_verify,[datalist JSONString]];
        NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSError * error;
        NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    }
}

-(PersonMarkModel *)insertUserGroupInLocal:(PersonMarkModel *)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=[paths objectAtIndex:0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id,groupname,ctime,status) VALUES ('%@','%@','%@','%@')",@"ID_Usergroups",sender._id,sender.groupname,sender.ctime,sender.status];
        BOOL result= [db executeUpdate:inserSQL];
        if (result) {
            NSString * sql=@"SELECT last_insert_rowid() from ID_Usergroups";
            FMResultSet * resultSet=[db executeQuery:sql];
            if ([resultSet next])
            {
                int rowid=[resultSet intForColumnIndex:0];
                sender.sysid=[NSString stringWithFormat:@"%d",rowid];
                [db close];
                [_dataArray insertObject:sender atIndex:[_dataArray count]-1];
                [_personTable reloadData];
                return  sender;
            }
        }
    }
    [db close];
    return  nil;
}

-(BOOL)updateUserlocalID:(PersonMarkModel *)group
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=[paths objectAtIndex:0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString * sql=[NSString stringWithFormat:@"update ID_Usergroups set _id='%@' where sysid='%@'",group._id,group.sysid];
        if ([db executeUpdate:sql]) {
            [db close];
            return true;
        }
    }
    [db close];
    return false;
}
-(void)insertUserGroupWithUrl:(PersonMarkModel *)group
{
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSDictionary * telDict=[NSDictionary dictionaryWithObjectsAndKeys:group.groupname,@"name", nil];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/insert_personal_groups?id=%@&verify=%@&groups=%@",_ids,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error==NULL) {
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dic) {
            NSArray * array=[dic objectForKey:@"insert_result"];
            NSDictionary * dataDict= [array objectAtIndex:0];
            group._id=[dataDict objectForKey:@"newID"];
            [self updateUserlocalID:group];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        [hud hide:YES afterDelay:2];
        hud.labelText = @"添加分组成功!";
        [self.navigationController.view addSubview:hud];
    }
}



-(void)updateMarkLocalData:(PersonMarkModel *)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名：
    NSString* TableName = @"ID_Usergroups";
    //    设置表名的标题
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (sysid integer PRIMARY KEY,_id TEXT, status TEXT, groupname TEXT, pid TEXT, ctime TEXT)",TableName];
    
    BOOL b=[db open];
    if (b)
        [db executeUpdate:create];
    CusModel *model = [[CusModel alloc] init];
    //从ID_Customer表里面读取_id列的值为model._id的这一行的数据
    NSString* searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_CustomerMark",@"_id",model._id];
    //                判断
    BOOL isExists = NO;
    if ([db open]) {
        //                从表里查找model._id
        FMResultSet* reselt = [db executeQuery:searchSql];
        while ([reselt next]) {//遍历这个表reselt的每一列
            //                        查询到列里的:_id
            NSString* _id = [reselt stringForColumn:@"_id"];
            if ([_id isEqualToString:model._id]) {
                isExists = YES;
                break;
            }
        }
    }
    if (isExists) { //判断存在  此时isExists 为YES   【存在 就更新】
        NSString* updateSQL = [NSString stringWithFormat:@"UPDATE ID_Usergroups set groupname='%@' where_id='%@' ",sender.groupname,sender._id];
        if ([db open]) {
            [db executeUpdate:updateSQL];//更新updateSql表的内容
        }
    }else{//否则就添加数据
        NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id,groupname,ctime,status) VALUES ('%@','%@','%@','%@')",@"ID_Usergroups",sender._id,sender.groupname,sender.ctime,sender.status];
        [db executeUpdate:inserSQL];
    }
    [db close];//关闭表
}

-(void)updatePersonLocalData:(PersonInfoModel *)sender
{
    //Database* db = [Database sharDatabase];
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名
    NSString* tableName = @"ID_Usercontact";
    //    设置表名行的标题
    NSString* creates = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (sysid integer PRIMARY KEY,_id TEXT,address TEXT,fax TEXT,userId TEXT,department TEXT, birthday TEXT, mobilePhone TEXT, telephone1 TEXT, telephone2 TEXT, cid TEXT, company TEXT, email TEXT, cshare TEXT, ctime TEXT, groupname TEXT, industry TEXT, internet TEXT, job TEXT, name TEXT, password TEXT, pid TEXT, pshare TEXT, remark TEXT, status TEXT,uid TEXT,cus_type Integer)",tableName];
    //    创建表的方法【创建数据库里的表】
    BOOL b=[db open];
    if (b)
        [db executeUpdate:creates];
    
    //从ID_Enterprise表里面读取_id列的值为model._ids的这一行的数据
    NSString* rearchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Usercontact",@"_id",sender._id];
    BOOL isExists = NO;
    if ([db open]) {
        //                    查询searchSql里的model.ids;
        FMResultSet* result = [db executeQuery:rearchSql];
        while ([result next]) {//便利表里的每一列
            //查询到列里的：ids
            NSString* ids = [result stringForColumn:@"_id"];
            if ([ids isEqualToString:sender._id]) {
                isExists = YES;
                break;
            }
        }
    }
    if (isExists) {//判断存在  此时isExists 为YES   【存在 就更新】
        //                    更新要更新对应的参数
        NSString* upDateSql = [NSString stringWithFormat:@"UPDATE %@ SET address=‘%@’,fax=‘%@’,department=‘%@’, birthday=‘%@’, mobilePhone=‘%@’, telephone1=‘%@’, telephone2=‘%@’, cid=‘%@’, company=‘%@’, email=‘%@’, industry=‘%@’, internet=‘%@’, job=‘%@’, name=‘%@’,remark=‘%@’,cus_type='%ld'  WHERE _id= '%@'",@"ID_Usercontact",sender.address,sender.fax,sender.department,sender.birthday,sender.mobilePhone,sender.telephone1,sender.telephone2,sender.cid,sender.company,sender.email,sender.industry,sender.internet,sender.job,sender.name,sender.remark,sender.cus_type,sender._id];
        
        if ([db open]) {
            
            //更新updateSql表的内容
            [db executeUpdate:upDateSql];
        }
    }else{//没有找到就添加数据   【否则就添加数据】
        NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (_id,address,fax,department, birthday, mobilePhone, telephone1, telephone2, cid, company, email, ctime , industry, internet, job, name, password, pid , remark , status,uid,cus_type) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%ld')",@"ID_Usercontact",sender._id,sender.address,sender.fax,sender.department,sender.birthday,sender.mobilePhone,sender.telephone1,sender.telephone2,sender.cid,sender.company,sender.email,sender.ctime,sender.industry,sender.internet,sender.job,sender.name,sender.password,sender.pid,sender.remark,sender.status,sender.uid,sender.cus_type];
        //把数据保存到数据库的@"ID_Enterprise"表里
        [db executeUpdate:inserSql];
    }
    [db close];
}

#pragma mark  【 UITableView 】
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PersonMarkModel * model=[_dataArray objectAtIndex:section];
    if ([model._id isEqualToString:@"-1"]) {
        return [[_personInfo objectForKey:@"-1"] count];
    }
    NSArray * arr=[_showData objectForKey:model._id];
    return arr.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==_dataArray.count-1)
    {
        return 0;
    }
    return 0;
}

//每行返回的高度；
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_personTable deselectRowAtIndexPath:indexPath animated:NO];
    PersonMarkModel * m=[_dataArray objectAtIndex:indexPath.section];
    if ([m._id isEqualToString:@"-1"]||indexPath.row!=0) {
        NSArray * arr= [_personInfo objectForKey:m._id];
        NSInteger index=0;
        if ([m._id isEqualToString:@"-1"])
        {
            index=indexPath.row;
        }else
        {
            index=indexPath.row-1;
        }
        PersonInfoModel * model=[arr objectAtIndex:index];
        PersonDetailViewController * detail=[[PersonDetailViewController alloc]init];
        detail.model=model;
        detail._mutableArray=_dataArray;
        [self.navigationController pushViewController:detail animated:YES];
        return;
    }
    if (indexPath.row==0)
    {
        if ([m.status isEqualToString:@"0"])
        {
            NSArray * personArray=[_personInfo objectForKey:m._id];
            if (personArray!=nil) {
                [_showData setObject:personArray forKey:m._id];
            }
            NSArray * arr= [_showData objectForKey:m._id];
            NSMutableArray * array=[[NSMutableArray alloc]init];
            for (int i =1; i<arr.count+1; i++) {
                NSIndexPath * paths=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [array addObject:paths];
            }
            [_personTable insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            m.status=@"1";
        }else
        {
            NSArray * arr= [_showData objectForKey:m._id];
            NSMutableArray * array=[[NSMutableArray alloc]init];
            for (int i =1; i<arr.count+1; i++) {
                NSIndexPath * paths=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [array addObject:paths];
            }
            [_showData removeObjectForKey:m._id];
            [_personTable deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            m.status=@"0";
        }
        [_personTable reloadData];
    }
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indetify=@"cell";static NSString* myCell = @"myCell";
    PersonMarkModel * model=[_dataArray objectAtIndex:indexPath.section];
    CustomerCell *tableCell=[tableView dequeueReusableCellWithIdentifier:indetify];
    if (tableCell==nil) {
        tableCell=[[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    if ( [model._id isKindOfClass:[NSNumber class]])
    {
        model._id= [NSString stringWithFormat:@"%@",model._id];
    }
    if ([model._id isEqualToString:@"-1"])
    {
        CustomerCell * cell =[tableView dequeueReusableCellWithIdentifier:myCell];
        if (cell == nil) {
            cell = [[CustomerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        }
        NSArray * arr=[_personInfo objectForKey:@"-1"];
        if (arr.count>0)
        {
            PersonInfoModel * model=[arr objectAtIndex:indexPath.row];
            cell._imgBiao.hidden=YES;
            cell.textstr=model.name;
            cell.telphoneNum=model.mobilePhone;
        }
        return cell;
    }else
    {
        if (indexPath.row==0) {
            if (_dataArray.count) {
                tableCell.model = [_dataArray objectAtIndex:indexPath.section];
            }
            if ([model.status isEqualToString:@"0"])
                tableCell._imgBiao.image = [UIImage imageNamed:@"expandable_arrow_right.png"];
            else
                tableCell._imgBiao.image = [UIImage imageNamed:@"expandable_arrow_down.png"];
            tableCell._imgBiao.hidden=NO;
            tableCell._telImage.hidden=YES;
        }else
        {
            NSArray *  arr=[_showData objectForKey:model._id];
            PersonInfoModel * model=[arr objectAtIndex:indexPath.row-1];
            tableCell._imgBiao.hidden=YES;
            tableCell.textstr=model.name;
            tableCell.telphoneNum=model.mobilePhone;
        }
    }
    return tableCell;
}

#pragma mark ----  【 删除cell行的方法】
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
}

#pragma mark 点击标签 展开信息栏
/*
- (void)showPersonInfo:(UIButton *)btn{
    btn.selected = !btn.selected;
    PersonTagBtn * button = (PersonTagBtn *)btn;
    
    [_headerBtns setObject:button forKey:@(button.index - 100)];
    
    [_personTable reloadData];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
