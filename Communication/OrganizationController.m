//
//  OrganizationController.m
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "OrganizationController.h"
#import "EnterpriseCell.h"

#import "DatabaseModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "Database.h"
#import "OrganizationModel.h"
#import "PublicAction.h"
#import "Reachability.h"
#import "PersonInfoViewController.h"
#import "pinyin.h"
#import "POAPinyin.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
@interface OrganizationController ()

@end

@implementation OrganizationController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"公司团队";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;
        
        UIBarButtonItem * btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        btn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=btn;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
//    标签下面的内容请求方法
//    [self EnterpriseStaffURL];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //组织构架标签请求方法
    
    
    // Do any additional setup after loading the view.
//   数组实例化
    _organizationArray = [NSMutableArray array]; //储存组织构架标签
    //储存组织构架里员工信息；
    
    dataStatus=1;
    _topArray=[NSMutableArray array];
    _organizaTotalDict=[NSMutableDictionary dictionary];
    _detailsMutableArray= [NSMutableDictionary dictionary];
    _employees=[NSMutableArray array];
    _secondArray=[NSMutableArray array];
    backPid=[NSMutableArray array];
    filteredArray=[[NSMutableArray alloc]init];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate=self;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];
    [PublicAction clearSearchBarcolor:searchBar];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 64 - searchBar.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    [self.view addSubview:_tableView];

    //    调用移除清除UITableView底部多余的分割线
    [self setExtraCellLineHidden:_tableView];
    [PublicAction tableViewCenter:_tableView];
    
    [self loadData];
}

-(void)loadData
{
    hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.labelText=@"加载中....";
    [self loadMarkLocalData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadStaffLocalData];
    });
/*
    Reachability * reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status=reach.currentReachabilityStatus;
    if (status==NotReachable) {
        
 (@"没有网络");
            }else{
 
    }*/
}

-(void)loadMarkLocalData
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    
    NSString* TableName = @"ID_Enterprise";
    //    创建表的方法   【创建数据库的操作】
    BOOL b=[db open];
    NSString * querySql=[NSString stringWithFormat:@"select * from %@",TableName];
    FMResultSet * result=nil;
    if ([db open])
        result=[db executeQuery:querySql];
    if (result==nil)
    {
        [self enterpriseURL];
        return;
    }
    while ([result next]) {
        DatabaseModel * new=[[DatabaseModel alloc]init];
        new._id=[result stringForColumn:@"_id"];
        new.pid=[result stringForColumn:@"pid"];
        new.departmentname=[result stringForColumn:@"departmentname"];
        new.eid=[result stringForColumn:@"eid"];
        new.ctime=[result stringForColumn:@"ctime"];
        if ([new.pid isEqualToString:@"0"])
        {
            [_topArray addObject:new];
        }
        
        NSMutableArray * arr=[_organizaTotalDict objectForKey:new.pid];
        
        if (arr.count==0)
        {
            [_organizaTotalDict setObject:[NSMutableArray arrayWithObject:new] forKey:new.pid];
        }else
        {
            [arr addObject:new];
            [_organizaTotalDict setObject:arr forKey:new.pid];
        }
    }
    [_tableView reloadData];
    [hub hide:YES];
}

-(void)loadStaffLocalData
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名
    NSString* tableName = @"ID_employees";
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
        [self queryStaffAction];
    }
    while ([result next]) {
        OrganizationModel* model = [[OrganizationModel alloc]init];
        model.username = [result stringForColumn:@"username"];
        model.fax = [result stringForColumn:@"fax"];
        model.userId = [result stringForColumn:@"userId"];
        model.ids = [result stringForColumn:@"ids"];
        model.departmentid = [result stringForColumn:@"departmentid"];
        model.position = [result stringForColumn:@"position"];
        model.mobilePhone = [result stringForColumn:@"mobilePhone"];
        model.telephone1 = [result stringForColumn:@"telephone1"];
        model.telephone2 = [result stringForColumn:@"telephone2"];
        model.extension = [result stringForColumn:@"extension"];
        model.ciocaasUserID = [result stringForColumn:@"ciocaasUserID"];
        model.email = [result stringForColumn:@"email"];
        model.flag = [result stringForColumn:@"flag"];
        model.ctimes = [result stringForColumn:@"ctime"];
        
        //把取出的model保存到可变数组里
        NSMutableArray * arr=[_detailsMutableArray objectForKey:model.departmentid];
        
        if (arr.count==0)
        {
            [_detailsMutableArray setObject:[NSMutableArray arrayWithObject:model] forKey:model.departmentid];
        }else
        {
            [arr addObject:model];
            [_detailsMutableArray setObject:arr forKey:model.departmentid];
        }
    }
}

-(void)back
{
    NSString * str=[backPid lastObject];
    if (str==NULL) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    dataStatus=1;
    _topArray=[_organizaTotalDict objectForKey:str];
    _secondArray=[_detailsMutableArray objectForKey:str];
    [_tableView reloadData];
    [backPid removeLastObject];
}


#pragma mark ====   UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (filteredArray.count>0) {
        return filteredArray.count;
    }
    if (section==0)
        return _topArray.count;
    else
        return _secondArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (filteredArray.count>0) {
        return 1;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (filteredArray.count>0)
    {
        OrganizationModel * model=[filteredArray objectAtIndex:indexPath.row];
        //tableCell.model = model.username;
        //tableCell.text=model.position;
        //tableCell._imgBiao.hidden=YES;
        //tableCell._tet.hidden=NO;
        return  nil;
    }else
    {
        static NSString* Cell = @"cell";
        EnterpriseCell* tableCell = [tableView dequeueReusableCellWithIdentifier:Cell];
        if (tableCell == nil) {
            tableCell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell];
        }
        if (indexPath.section==0)
        {
            if (dataStatus==0)
            {
                OrganizationModel * model=[_employees objectAtIndex:indexPath.row];
                tableCell.model = model.username;
                tableCell.text=model.position;
                tableCell._imgBiao.hidden=YES;
                tableCell._tet.hidden=NO;
            }else
            {
                if (_topArray.count) {
                    DatabaseModel * model= [_topArray objectAtIndex:indexPath.row];
                    tableCell.model =model.departmentname;
                    tableCell._imgBiao.hidden=NO;
                    tableCell._tet.hidden=YES;
                }
            }
        }else
        {
            OrganizationModel * model=[_secondArray objectAtIndex:indexPath.row];
            tableCell.model = model.username;
            tableCell.text=model.position;
            tableCell._imgBiao.hidden=YES;
            tableCell._tet.hidden=NO;
        }
        return tableCell;
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     _enTerpriseID   企业标签ID
     _employees      企业员工departmentid 用来和企业标签进行判断的*/
    if (indexPath.section==1||filteredArray.count>0) {
        OrganizationModel * model=nil;
        if (filteredArray.count>0) {
            model=[filteredArray objectAtIndex:indexPath.row];
        }else
        {
            model=[_secondArray objectAtIndex:indexPath.row];
        }
        PersonInfoViewController* popu = [[PersonInfoViewController alloc]init];
        popu.model=model;
        [self.navigationController pushViewController:popu animated:YES];
        return;
    }
    DatabaseModel * model=[_topArray objectAtIndex:indexPath.row];
    NSMutableArray * arr=[_organizaTotalDict objectForKey:model._id];
    if (arr.count==0)
    {
        if (dataStatus==0)
        {
            OrganizationModel * model=[_employees objectAtIndex:indexPath.row];
            PersonInfoViewController* popu = [[PersonInfoViewController alloc]init];
            popu.model=model;
            [self.navigationController pushViewController:popu animated:YES];
            return;
        }else
        {
            _employees=[_detailsMutableArray objectForKey:model._id];
            if (_employees.count==0)
                return;
            _topArray=_employees;
            dataStatus=0;
        }
        
    }else
    {
        _secondArray=[_detailsMutableArray objectForKey:model._id];
        _topArray=arr;
        dataStatus=1;
    }
    [backPid addObject:model.pid];
    [tableView reloadData];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
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

#pragma mark === [网络请求   企业标签]
-(void)enterpriseURL{
    //管理器
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    //    取出保存的数据
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* _id = [defaults objectForKey:@"nid"];
    NSString* eid = [defaults objectForKey:@"eid"];
    NSString* verify = [defaults objectForKey:@"verify"];
    NSString* auchCode = [defaults objectForKey:@"auchCode"];
    //    设置参数
    NSDictionary * dict=@{@"id":_id,@"eid":eid,@"verify":verify,@"auchCode":auchCode};
    //    发送请求
    [manager GET:@"http://open.ciopaas.com/Admin/Info/get_EnterpriseArchitecture?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil ;
        NSDictionary* dicti = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
        if (error) {

        }else{
            NSArray *organiza = [dicti objectForKey:@"OrganizationalStructure"];
            //NSMutableDictionary * dict=[NSMutableDictionary dictionary];
            for (NSDictionary *content in organiza) {
                DatabaseModel *model = [[DatabaseModel alloc] init];
                model._id = [content objectForKey:@"id"];
                model.pid = [content objectForKey:@"pid"];
                model.departmentname = [content objectForKey:@"departmentname"];
                model.eid = [content objectForKey:@"eid"];
                model.ctime = [content objectForKey:@"ctime"];
                
                if ([model.pid isEqualToString:@"0"])
                {
                    [_topArray addObject:model];
                }
                
                NSMutableArray * arr=[_organizaTotalDict objectForKey:model.pid];
                
                if (arr.count==0)
                {
                    [_organizaTotalDict setObject:[NSMutableArray arrayWithObject:model] forKey:model.pid];
                }else
                {
                    [arr addObject:model];
                    [_organizaTotalDict setObject:arr forKey:model.pid];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hub hide:YES];
                });
                //[_organizationArray addObject:model];
                [self updateMarkLocalData:model];
            }
            [_tableView reloadData];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

-(void)updateMarkLocalData:(DatabaseModel *)model
{
    //Database* db = [Database sharDatabase];
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    NSString* TableName = @"ID_Enterprise";
    //    设置表名的标题
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id text, pid TEXT, departmentname TEXT, eid TEXT, ctime TEXT)",TableName];
    //    创建表的方法   【创建数据库的操作】
    BOOL b=[db open];
    if (b)
        [db executeUpdate:create];
       //[db executeQuery:create];
    //从ID_Enterprise表里面读取_id列的值为model._id的这一行的数据
    NSString*searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Enterprise",@"_id",model._id];
    
    BOOL isExists = NO;
    FMResultSet *result = [db executeQuery:searchSql];
    while ([result next]) { //遍历这个表里的每一列
        //查询到列里的："_id"
        NSString *_id = [result stringForColumn:@"_id"];
        if ([_id isEqualToString:model._id]) {
            
            isExists = YES;
            
            break;
        }
    }
    if (isExists) {//判断存在  此时isExists 为YES   【存在 就更新】
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@',%@ = '%@', %@ ='%@',%@ = '%@' WHERE %@ = '%@'",@"ID_Enterprise",@"pid",model.pid,@"departmentname",model.departmentname,@"eid",model.eid,@"ctime",model.ctime,@"_id",model._id];
        [db executeUpdate:updateSql];
    }else{//否则就添加数据
        NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id, pid, departmentname,eid,  ctime) VALUES ('%@','%@','%@','%@','%@')",@"ID_Enterprise",model._id,model.pid,model.departmentname,model.eid,model.ctime];
        //把数据保存到数据库的@"ID_Enterprise"表里
        [db executeUpdate:inserSQL];
    }
    [db close];
}

-(void)queryStaffAction
{
    //[self performSelectorOnMainThread:@selector(hello) withObject:nil waitUntilDone:NO];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    //    取出保存的数据
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    //    发送企业员工的请求
    NSString * url=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/get_company_member?id=%@&verify=%@&eid=%@",_ids,_verify,_eid];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary* dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray* companyMember = [dictionary objectForKey:@"CompanyMember"];
    for (NSDictionary* content  in companyMember) {
        OrganizationModel* model = [[OrganizationModel alloc]init];
        model.username = [content objectForKey:@"username"];
        model.fax = [content objectForKey:@"fax"];
        model.userId = [content objectForKey:@"userId"];
        model.ids = [content objectForKey:@"id"];
        model.departmentid = [content objectForKey:@"departmentid"];
        model.position = [content objectForKey:@"position"];
        model.mobilePhone = [content objectForKey:@"mobilePhone"];
        model.telephone1 = [content objectForKey:@"telephone1"];
        model.telephone2 = [content objectForKey:@"telephone2"];
        model.extension = [content objectForKey:@"extension"];
        model.ciocaasUserID = [content objectForKey:@"ciocaasUserID"];
        model.email = [content objectForKey:@"email"];
        model.flag = [content objectForKey:@"flag"];
        model.ctimes = [content objectForKey:@"ctime"];
        
        //把取出的model保存到可变数组里
        NSMutableArray * arr=[_detailsMutableArray objectForKey:model.departmentid];
        
        if (arr.count==0)
        {
            [_detailsMutableArray setObject:[NSMutableArray arrayWithObject:model] forKey:model.departmentid];
        }else
        {
            [arr addObject:model];
            [_detailsMutableArray setObject:arr forKey:model.departmentid];
        }
        [self updatePersonLocalData:model];
    }
}

-(void)updatePersonLocalData:(OrganizationModel *)model
{
    //Database* db = [Database sharDatabase];
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    //    设置表名
    NSString* tableName = @"ID_employees";
    //    设置表名行的标题
    NSString* creates = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ids text,username TEXT,fax TEXT,userId TEXT,departmentid TEXT, position TEXT, mobilePhone TEXT, telephone1 TEXT, telephone2 TEXT, extension TEXT, ciocaasUserID TEXT, email TEXT, flag TEXT, ctime TEXT,condition TEXT )",tableName];
    //    创建表的方法【创建数据库里的表】
    BOOL b=[db open];
    if (b)
        [db executeUpdate:creates];
    
    //从ID_Enterprise表里面读取_id列的值为model._ids的这一行的数据
    NSString* rearchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_employees",@"ids",model.ids];
    BOOL isExists = NO;
    if ([db open]) {
        //                    查询searchSql里的model.ids;
        FMResultSet* result = [db executeQuery:rearchSql];
        while ([result next]) {//便利表里的每一列
            //查询到列里的：ids
            NSString* ids = [result stringForColumn:@"ids"];
            if ([ids isEqualToString:model.ids]) {
                isExists = YES;
                break;
            }
        }
    }
    NSString * condition=[self getCondition:model];
    if (isExists) {//判断存在  此时isExists 为YES   【存在 就更新】
        //                    更新要更新对应的参数
        NSString* upDateSql = [NSString stringWithFormat:@"UPDATE %@ SET username = '%@',fax = '%@', ids ='%@',userId = '%@' ,departmentid = '%@',position = '%@',mobilePhone = '%@',telephone1 = '%@', telephone2 ='%@',extension = '%@' ,ciocaasUserID = '%@',email = '%@',flag = '%@',ctimes = '%@',condition = '%@' WHERE ids = '%@'",@"ID_employees",model.username,model.fax,model.ids,model.userId,model.departmentid,model.position,model.mobilePhone,model.telephone1,model.telephone2,model.extension,model.ciocaasUserID,model.email,model.flag,model.ctimes,condition,model.ids];
        
        
        if ([db open]) {
            
            //更新updateSql表的内容
            [db executeQuery:upDateSql];
        }
    }else{//没有找到就添加数据   【否则就添加数据】
        NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (username, fax, ids, userId,departmentid, position, mobilePhone, telephone1, telephone2, extension, ciocaasUserID, email, flag, ctime,condition) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"ID_employees",model.username,model.fax,model.ids,model.userId,model.departmentid,model.position,model.mobilePhone,model.telephone1,model.telephone2,model.extension,model.ciocaasUserID,model.email,model.flag,model.ctimes,condition];
        //把数据保存到数据库的@"ID_Enterprise"表里
        [db executeUpdate:inserSql];
    }
    [db close];
}

-(NSString *)getCondition:(OrganizationModel *)model
{
    NSString * name= model.username;
    NSString * string=[[POAPinyin quickConvert:name] lowercaseString];
    NSMutableString * firstString=[[NSMutableString alloc]init];
    NSMutableString * otherString=[[NSMutableString alloc]init];
    NSArray * values=[NSArray arrayWithObjects:@"abc",@"def",@"ghi",@"jkl",@"mno",@"pqrs",@"tuv",@"wxyz", nil];
    NSArray * keys=[NSArray arrayWithObjects: @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    NSDictionary * dict=[NSDictionary dictionaryWithObjects:values forKeys:keys];
    for (int i=0; i<name.length; i++)
    {
        char str=pinyinFirstLetter([name characterAtIndex:i]);
        for (NSString * key in dict.allKeys)
        {
            NSString * value=[dict objectForKey:key];
            NSRange range= [value rangeOfString:[NSString stringWithFormat:@"%c",str]];
            if (range.location!=NSNotFound) {
                [otherString appendString:key];
            }
        }
        [firstString appendString:[NSString stringWithFormat:@"%c",str]];
    }
    NSString * returnStr=[NSString stringWithFormat:@"%@;%@;%@",otherString,firstString,string];
    return  returnStr;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchModelBycondition:searchText];
    [_tableView reloadData];
}

-(void)searchModelBycondition:(NSString *)condition
{
    [filteredArray removeAllObjects];
    NSString * regex = @"(^[0-9]+$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (condition.length>0)
    {
        if ([pred evaluateWithObject:condition])
        {
            [self searchModelBynumber:condition];
        }else
        {
            [self searchModelByname:condition];
        }
    }
}

-(void)searchModelByname:(NSString *)name
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSMutableString * sql=[NSMutableString stringWithFormat:@"SELECT * FROM ID_employees WHERE username LIKE '%%%@%%'",name];
        [sql appendString:[NSString stringWithFormat:@" UNION SELECT * FROM ID_employees WHERE condition LIKE '%%%@%%'",name]];
        FMResultSet * result= [db executeQuery:sql];
        while([result next])
        {
            OrganizationModel* model = [[OrganizationModel alloc]init];
            model.username = [result stringForColumn:@"username"];
            model.fax = [result stringForColumn:@"fax"];
            model.userId = [result stringForColumn:@"userId"];
            model.ids = [result stringForColumn:@"ids"];
            model.departmentid = [result stringForColumn:@"departmentid"];
            model.position = [result stringForColumn:@"position"];
            model.mobilePhone = [result stringForColumn:@"mobilePhone"];
            model.telephone1 = [result stringForColumn:@"telephone1"];
            model.telephone2 = [result stringForColumn:@"telephone2"];
            model.extension = [result stringForColumn:@"extension"];
            model.ciocaasUserID = [result stringForColumn:@"ciocaasUserID"];
            model.email = [result stringForColumn:@"email"];
            model.flag = [result stringForColumn:@"flag"];
            model.ctimes = [result stringForColumn:@"ctime"];
            
            [filteredArray addObject:model];
        }
    }
    [db close];
}

-(void)searchModelBynumber:(NSString *)number
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSMutableString * sql=[NSMutableString stringWithFormat:@"SELECT * FROM ID_employees WHERE mobilePhone LIKE '%%%@%%'",number];
        [sql appendString:[NSString stringWithFormat:@" UNION SELECT * FROM ID_employees WHERE telephone1 LIKE '%%%@%%'",number]];
        [sql appendString:[NSString stringWithFormat:@" UNION SELECT * FROM ID_employees WHERE telephone2 LIKE '%%%@%%'",number]];
        [sql appendString:[NSString stringWithFormat:@" UNION SELECT * FROM ID_employees WHERE condition LIKE '%%%@%%'",number]];
        NSLog(@"%@",sql);
        FMResultSet * result= [db executeQuery:sql];
        while([result next])
        {
            OrganizationModel* model = [[OrganizationModel alloc]init];
            model.username = [result stringForColumn:@"username"];
            model.fax = [result stringForColumn:@"fax"];
            model.userId = [result stringForColumn:@"userId"];
            model.ids = [result stringForColumn:@"ids"];
            model.departmentid = [result stringForColumn:@"departmentid"];
            model.position = [result stringForColumn:@"position"];
            model.mobilePhone = [result stringForColumn:@"mobilePhone"];
            model.telephone1 = [result stringForColumn:@"telephone1"];
            model.telephone2 = [result stringForColumn:@"telephone2"];
            model.extension = [result stringForColumn:@"extension"];
            model.ciocaasUserID = [result stringForColumn:@"ciocaasUserID"];
            model.email = [result stringForColumn:@"email"];
            model.flag = [result stringForColumn:@"flag"];
            model.ctimes = [result stringForColumn:@"ctime"];
            
            [filteredArray addObject:model];
        }
    }
    [db close];
}

#pragma mark  清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];

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
