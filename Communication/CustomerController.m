//
//  CustomerController.m
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "CustomerController.h"
#import "Newcustomer.h"   //新客户创建
#import "CustomerCell.h"
#import "CusModel.h"

#import "AFHTTPRequestOperationManager.h"
#import "Database.h"     //数据库的类
#import "PublicAction.h"
#import "CustomerModel.h"
#import "CusInfoViewController.h"

@interface CustomerController ()

@end

@implementation CustomerController
@synthesize cusModel;
-(void)setModel:(CuclabelModel *)model{
    if (_model!=model) {
        _model = model;

    }
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"客户通讯录";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;
        UIBarButtonItem * btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        btn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=btn;
        
        UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_btn_white.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(addCustomer)];
        right.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=right;
    }
    return self;
}

-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)addCustomer
{
    Newcustomer * customer=[[Newcustomer alloc]init];
    [self.navigationController pushViewController:customer animated:YES];
}

-(void)addCustoArray:(CustomerModel*)addModel
{
    if ([addModel.cid isEqual:[NSNull null]]||addModel.cid==nil)
    {
        addModel.cid=@"";
    }
    if ([addModel.cid isEqualToString:@""]||[addModel.cid isEqualToString:@"0"])
    {
        NSMutableArray * arr=[_customerDict objectForKey:@"-1"];
        
        if (arr.count==0)
        {
            [_customerDict setObject:[NSMutableArray arrayWithObject:addModel] forKey:@"-1"];
        }else
        {
            [arr addObject:addModel];
            [_customerDict setObject:arr forKey:@"-1"];
        }
    }else
    {
        if (addModel.cid)
        {
            NSArray * cids=[addModel.cid componentsSeparatedByString:@","];
            for (NSString * str in cids)
            {
                NSMutableArray * arr=[_customerDict objectForKey:str];
                
                if (arr.count==0)
                {
                    [_customerDict setObject:[NSMutableArray arrayWithObject:addModel] forKey:str];
                }else
                {
                    [arr addObject:addModel];
                    [_customerDict setObject:arr forKey:str];
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.optionStatus==2||self.optionStatus==1)
    {
        [_customerDict removeAllObjects];
        [_mutableArray removeAllObjects];
        [_showCusDict removeAllObjects];
        [self loadData];
    }
    self.optionStatus=0;
}


-(void)viewWillDisappear:(BOOL)animated
{
    for (CusModel * m in _mutableArray)
    {
        m.status=0;
    }
    [_showCusDict removeAllObjects];
}

-(void)loadData
{
    [self loadMarkLocalData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadStaffLocalData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [_tableView reloadData];
        });
    });
}

-(void)loadMarkLocalData
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    
    NSString* TableName = @"ID_CustomerMark";
    //    创建表的方法   【创建数据库的操作】
    BOOL b=[db open];
    NSString * querySql=[NSString stringWithFormat:@"select * from %@",TableName];
    FMResultSet * result=nil;
    if ([db open])
        result=[db executeQuery:querySql];
    if (result==nil)
    {
        [self getCustomerMarkURL];
        return;
    }
    while ([result next]) {
        CusModel *model = [[CusModel alloc] init];
        model._id = [result stringForColumn:@"_id"];
        model.pid = [result stringForColumn:@"pid"];
        model.groupname = [result stringForColumn:@"groupname"];
        model.uid = [result stringForColumn:@"uid"];
        model.ctime = [result stringForColumn:@"ctime"];
        model.status=0;
        [_mutableArray addObject:model];
    }
    CusModel *model = [[CusModel alloc] init];
    model._id=@"-1";
    [_mutableArray addObject:model];
    [_tableView reloadData];
}

-(void)loadStaffLocalData
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名
    NSString* tableName = @"ID_Customer";
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
        [self getCustomerURL];
    }
    while ([result next]) {
        CustomerModel* model = [[CustomerModel alloc]init];
        model.sysid=[result stringForColumn:@"sysid"];
        model.name = [result stringForColumn:@"name"];
        model.fax = [result stringForColumn:@"fax"];
        model.userId = [result stringForColumn:@"userId"];
        model._id = [result stringForColumn:@"_id"];
        model.department = [result stringForColumn:@"department"];
        model.job = [result stringForColumn:@"job"];
        model.mobilePhone = [result stringForColumn:@"mobilePhone"];
        model.telephone1 = [result stringForColumn:@"telephone1"];
        model.telephone2 = [result stringForColumn:@"telephone2"];
        model.company = [result stringForColumn:@"company"];
        model.cshare = [result stringForColumn:@"cshare"];
        model.email = [result stringForColumn:@"email"];
        model.cid = [result stringForColumn:@"cid"];
        model.ctime = [result stringForColumn:@"ctime"];
        model.industry = [result stringForColumn:@"industry"];
        model.internet = [result stringForColumn:@"internet"];
        model.remark = [result stringForColumn:@"remark"];
        model.birthday = [result stringForColumn:@"birthday"];
        model.contactID=[result stringForColumn:@"contactid"];
        model.sign=[result intForColumn:@"sign"];
        //把取出的model保存到可变数组里
        [self addCustoArray:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.optionStatus=0;
    _mutableArray = [NSMutableArray array];
    _customerDict=[NSMutableDictionary dictionary];
    _showCusDict=[NSMutableDictionary dictionary];
    //_topCustome=[NSMutableArray array];
    [self loadData];
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [PublicAction clearSearchBarcolor:searchBar];
    [self.view addSubview:searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 48 - searchBar.frame.size.height )];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    [PublicAction tableViewCenter:_tableView];
    [self.view addSubview:_tableView];
    //    调用移除清除UITableView底部多余的分割线
    [self setExtraCellLineHidden:_tableView];
}
#pragma mark === 【rightBarButton 】
-(void)rightBarButton:(UIBarButtonItem*)rihgt{
    Newcustomer* newcust = [[Newcustomer alloc] init];
    [self.navigationController pushViewController:newcust animated:YES];
}

#pragma mark  = [UITableView]
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger counts = _mutableArray.count;
    return counts;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CusModel * model=[_mutableArray objectAtIndex:section];
    if ([model._id isEqualToString:@"-1"])
        return [[_customerDict objectForKey:@"-1"] count];
    NSArray * arr=[_showCusDict objectForKey:model._id];
    return arr.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"Cell";static NSString* myCell = @"myCell";
    CusModel * m=[_mutableArray objectAtIndex:indexPath.section];
    CustomerCell * tableCell =[tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell == nil) {
        tableCell = [[CustomerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    if ( [m._id isKindOfClass:[NSNumber class]])
    {
        m._id= [NSString stringWithFormat:@"%@",m._id];
    }
    if ([m._id isEqualToString:@"-1"])
    {
        CustomerCell * cell =[tableView dequeueReusableCellWithIdentifier:myCell];
        if (cell == nil) {
            cell = [[CustomerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        }
        NSArray * arr=[_customerDict objectForKey:@"-1"];
        if (arr.count>0) {
            CustomerModel * model=[arr objectAtIndex:indexPath.row];
            cell._imgBiao.hidden=YES;
            cell.textstr=model.name;
            cell.telphoneNum=model.mobilePhone;
        }
        return  cell;
    }else
    {
        if (indexPath.row==0) {
            if (_mutableArray.count) {
                tableCell.model = [_mutableArray objectAtIndex:indexPath.section];
            }
            if (m.status==0)
                tableCell._imgBiao.image = [UIImage imageNamed:@"expandable_arrow_right.png"];
            else
                tableCell._imgBiao.image = [UIImage imageNamed:@"expandable_arrow_down.png"];
            tableCell._imgBiao.hidden=NO;
            tableCell._telImage.hidden=YES;
        }else
        {
            NSArray *  arr=[_showCusDict objectForKey:m._id];
            CustomerModel * model=[arr objectAtIndex:indexPath.row-1];
            tableCell._imgBiao.hidden=YES;
            tableCell.textstr=model.name;
            tableCell.telphoneNum=model.mobilePhone;
        }
    }
    
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CusModel * m=[_mutableArray objectAtIndex:indexPath.section];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([m._id isEqualToString:@"-1"]||indexPath.row!=0) {
        NSArray * arr= [_customerDict objectForKey:m._id];
        NSInteger index=0;
        if ([m._id isEqualToString:@"-1"])
        {
            index=indexPath.row;
        }else
        {
            index=indexPath.row-1;
        }
        CustomerModel * model=[arr objectAtIndex:index];
        CusInfoViewController * customer=[[CusInfoViewController alloc]init];
        customer.model=model;
        customer._mutableArray=_mutableArray;
        [self.navigationController pushViewController:customer animated:YES];
        return;
    }
    if (indexPath.row==0)
    {
        if (m.status==0)
        {
            NSArray * customers=[_customerDict objectForKey:m._id];
            if (customers!=nil) {
                [_showCusDict setObject:customers forKey:m._id];
            }
           NSArray * arr= [_showCusDict objectForKey:m._id];
            NSMutableArray * array=[[NSMutableArray alloc]init];
            for (int i =1; i<arr.count+1; i++) {
                NSIndexPath * paths=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [array addObject:paths];
            }
            [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            m.status=1;
            
        }else
        {
            NSArray * arr= [_showCusDict objectForKey:m._id];
            NSMutableArray * array=[[NSMutableArray alloc]init];
            for (int i =1; i<arr.count+1; i++) {
                NSIndexPath * paths=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [array addObject:paths];
            }
            [_showCusDict removeObjectForKey:m._id];
            [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];

            m.status=0;
        }
        [_tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        //[cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)updateMarkLocalData:(CusModel *)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名：
    NSString* TableName = @"ID_CustomerMark";
    //    设置表名的标题
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id text, uid TEXT, groupname TEXT, pid TEXT, ctime TEXT)",TableName];
    
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
        NSString* updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@',%@ = '%@',%@ = '%@', %@= '%@' WHERE %@ = '%@'",@"ID_CustomerMark",@"_id",sender._id,@"uid",sender.uid,@"pid",sender.pid,@"groupname",sender.groupname,@"ctime",sender.ctime];
        if ([db open]) {
            [db executeUpdate:updateSQL];//更新updateSql表的内容
        }
    }else{//否则就添加数据
        NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id , pid , uid ,groupname , ctime) VALUES ('%@','%@','%@','%@','%@')",@"ID_CustomerMark",sender._id,sender.pid,sender.uid,sender.groupname,sender.ctime];
        [db executeUpdate:inserSQL];
    }
    [db close];//关闭表
}

-(void)updateCostomerLocalData:(CustomerModel *)sender
{
    //Database* db = [Database sharDatabase];
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名
    NSString* tableName = @"ID_Customer";
    //    设置表名行的标题
    NSString* creates = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (sysid integer PRIMARY KEY,_id TEXT,address TEXT,fax TEXT,userId TEXT,department TEXT, birthday TEXT, mobilePhone TEXT, telephone1 TEXT, telephone2 TEXT, cid TEXT, company TEXT, email TEXT, cshare TEXT, ctime TEXT, groupname TEXT, industry TEXT, internet TEXT, job TEXT, name TEXT, password TEXT, pid TEXT, pshare TEXT, remark TEXT, status TEXT,uid TEXT,contactid TEXT,sign integer default 0)",tableName];
    //    创建表的方法【创建数据库里的表】
    BOOL b=[db open];
    if (b)
        [db executeUpdate:creates];
    
    //从ID_Enterprise表里面读取_id列的值为model._ids的这一行的数据
    NSString* rearchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Customer",@"_id",sender._id];
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
        NSString* upDateSql = [NSString stringWithFormat:@"UPDATE %@ SET address=‘%@’,fax=‘%@’,department=‘%@’, birthday=‘%@’, mobilePhone=‘%@’, telephone1=‘%@’, telephone2=‘%@’, cid=‘%@’, company=‘%@’, email=‘%@’, cshare=‘%@’, industry=‘%@’, internet=‘%@’, job=‘%@’, name=‘%@’,remark=‘%@’ WHERE _id= '%@'",@"ID_Customer",sender.address,sender.fax,sender.department,sender.birthday,sender.mobilePhone,sender.telephone1,sender.telephone2,sender.cid,sender.company,sender.email,sender.cshare,sender.industry,sender.internet,sender.job,sender.name,sender.remark,sender._id];
        
        if ([db open]) {
            
            //更新updateSql表的内容
            [db executeUpdate:upDateSql];
        }
    }else{//没有找到就添加数据   【否则就添加数据】
        NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (_id,address,fax,userId,department, birthday, mobilePhone, telephone1, telephone2, cid, company, email, cshare, ctime, groupname , industry, internet, job, name, password, pid, pshare , remark , status,uid) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"ID_Customer",sender._id,sender.address,sender.fax,sender.userId,sender.department,sender.birthday,sender.mobilePhone,sender.telephone1,sender.telephone2,sender.cid,sender.company,sender.email,sender.cshare,sender.ctime,sender.groupname,sender.industry,sender.internet,sender.job,sender.name,sender.password,sender.pid,sender.pshare,sender.remark,sender.status,sender.uid];
        //把数据保存到数据库的@"ID_Enterprise"表里
        [db executeUpdate:inserSql];
    }
    [db close];
}

#pragma mark  === [网络请求  -- 客户通讯录]

-(void)getCustomerURL
{
    //管理器
    AFHTTPRequestOperationManager* Manager = [AFHTTPRequestOperationManager manager];
    Manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //取出保存的数据
    NSString *_id = [defaults objectForKey:@"nid"];
    NSString* userid = [defaults objectForKey:@"userid"];
    NSString* eid = [defaults objectForKey:@"eid"];
    NSString* verify = [defaults objectForKey:@"verify"];
    NSString* mobile = [defaults objectForKey:@"Num"];
    NSString* passwd = [defaults objectForKey:@"Password"];
    NSString* auchCode = [defaults objectForKey:@"auchCode"];
    
    NSDictionary* dicts = @{@"id":_id,@"userid":userid,@"verify":verify,@"eid":eid,@"auchCode":auchCode,@"mobile":mobile,@"passwd":passwd};
    [Manager GET:@"http://open.ciopaas.com/Admin/Info/get_CustomerAddressBook?" parameters:dicts success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {
            
        }else{
            NSArray* customer = [dict objectForKey:@"CustomerMailingList"];
            for (NSDictionary *content in customer) {
                CustomerModel *model = [[CustomerModel alloc] init];
                NSArray * keys=[content allKeys];
                for (NSString * str in keys) {
                    if ([str isEqualToString:@"id"])
                    {
                        model._id=[content objectForKey:str];
                    }else
                    {
                        [model setValue:[content objectForKey:str] forKey:str];
                    }
                }
                [self addCustoArray:model];
                [self updateCostomerLocalData:model];
            }
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)getCustomerMarkURL
{
    //管理器
    AFHTTPRequestOperationManager* Manager = [AFHTTPRequestOperationManager manager];
    Manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    //取出保存的数据
    NSString *_id = [defaults objectForKey:@"nid"];
    NSString* eid = [defaults objectForKey:@"eid"];
    NSString* verify = [defaults objectForKey:@"verify"];
    NSString* auchCode = [defaults objectForKey:@"auchCode"];

    NSDictionary* dicts = @{@"id":_id,@"verify":verify,@"eid":eid,@"auchCode":auchCode};
    //    发送请求
    [Manager GET:@"http://open.ciopaas.com/Admin/Info/get_company_customer_groups?" parameters:dicts success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {

        }else{
            NSArray* customer = [dict objectForKey:@"customergroupslist"];
            for (NSDictionary *content in customer) {
                CusModel *model = [[CusModel alloc] init];
                model._id = [content objectForKey:@"id"];
                model.pid = [content objectForKey:@"pid"];
                model.groupname = [content objectForKey:@"groupname"];
                model.uid = [content objectForKey:@"uid"];
                model.ctime = [content objectForKey:@"ctime"];
                model.status=0;
                [_mutableArray addObject:model];
                [self updateMarkLocalData:model];
            }
            CusModel *model = [[CusModel alloc] init];
            model._id=@"-1";
            [_mutableArray addObject:model];
            [_tableView reloadData];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

@end
