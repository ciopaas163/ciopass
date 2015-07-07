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
#import "PopulationController.h"    //标签内的人
#import "TextViewController.h"

@interface OrganizationController ()

<UITableViewDataSource,UITableViewDelegate>
@end

@implementation OrganizationController
-(void)viewWillAppear:(BOOL)animated{
    //组织构架标签请求方法
    [self enterpriseURL];
//    标签下面的内容请求方法
//    [self EnterpriseStaffURL];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//   数组实例化
    _organizationArray = [NSMutableArray array]; //储存组织构架标签
    _detailsMutableArray= [NSMutableArray array];//储存组织构架里员工信息；
    
    _iosMutableArray = [NSMutableArray array];//开发部
    _testMutableArrar = [NSMutableArray array];//测试部
    _marketMutableArray = [NSMutableArray array];//市场部
    _headquartersArray = [NSMutableArray array];//总部
    _testMutableArrar = [NSMutableArray array];//测试小组
    _organizationArray = [NSMutableArray array];//海外部
    _huizhouArray = [NSMutableArray array];//惠州测试
    _shenzhenAyyay = [NSMutableArray array];//深圳分公司
    _administrationArray = [NSMutableArray array];//行政部
    _hrArray = [NSMutableArray array];//人事部
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"组织构架";
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 64 - searchBar.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    [self.view addSubview:_tableView];

    //    调用移除清除UITableView底部多余的分割线
    [self setExtraCellLineHidden:_tableView];
    NSLog(@"AAAAAAAA:%@",self.Number);


}


#pragma mark ====   UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger countx = _organizationArray.count;
    NSLog(@"geshu:%ld",(long)countx);
    return countx;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"cell";
    EnterpriseCell* tableCell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell == nil) {
        tableCell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell];
    }
    //     NSArray * labelArray = @[@"开发",@"测试部",@"产品部",@"市场部",@"销售部",@"总部",@"海外部",@"陈东明",@"赵勇",@"陈雄"];

    NSLog(@"indx.row==%ld",(long)indexPath.section);

    if (_organizationArray.count) {
        tableCell.model = [_organizationArray objectAtIndex:indexPath.section];
    }


    return tableCell;
}

#pragma mark === [网络请求   企业标签]
-(void)enterpriseURL{

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
    NSString* timestamp = [defaults objectForKey:@"timestamp"];
    //    设置参数
    NSDictionary* dict = @{@"id":_id,@"eid":eid,@"verify":verify,@"auchCode":auchCode,@"timestamp":timestamp};
    //    发送请求
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
//                _enTerpriseID;// 企业标签ID
//                _employees;//企业员工departmentid 用来和企业标签进行判断的

                _enTerpriseID = model._id;
#pragma mark   === [要进行判断的_id]
                
                NSLog(@"model._id*******:%@",_enTerpriseID);
                
                [_organizationArray addObject:model];

                //                数据库的类实例化
                Database* db = [Database sharDatabase];

                //从ID_Enterprise表里面读取_id列的值为model._id的这一行的数据
                NSString*searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Enterprise",@"_id",model._id];

                BOOL isExists = NO;
                if ([db.datadb open]) {
                    //查询searchSql里的model._id
                    FMResultSet *result = [db.datadb executeQuery:searchSql];
                    while ([result next]) { //遍历这个表里的每一列
                        //查询到列里的："_id"
                        NSString *_id = [result stringForColumn:@"_id"];
                        if ([_id isEqualToString:model._id]) {

                            isExists = YES;

                            break;
                        }
                    }

                    [db.datadb close]; //关闭表
                }
                if (isExists) {//判断存在  此时isExists 为YES   【存在 就更新】
                    NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@',%@ = '%@', %@ ='%@',%@ = '%@' WHERE %@ = '%@'",@"ID_Enterprise",@"pid",model.pid,@"departmentname",model.departmentname,@"eid",model.eid,@"ctime",model.ctime,@"_id",model._id];
                    if ([db.datadb open]) {//打开表
                        //更新updateSql表的内容
                        [db.datadb executeUpdate:updateSql];
                        [db.datadb close];
                    }
                }else{//否则就添加数据
                    NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id, pid, departmentname,eid,  ctime) VALUES ('%@','%@','%@','%@','%@')",@"ID_Enterprise",model._id,model.pid,model.departmentname,model.eid,model.ctime];
                    //把数据保存到数据库的@"ID_Enterprise"表里
                    [db saveSql:inserSQL];
                     NSLog(@"&&&&&&:%@",inserSQL);
                }


            }


            [_tableView reloadData];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"~~~~get:%@",error);
    }];
    /*
}
#pragma mark === [取企业员工数据接口   ]
-(void)EnterpriseStaffURL{
#pragma mark == {保存数据到本地数据库}
   Database * dbDate = [Database sharDatabase];
    NSLog(@"db员工:%@",dbDate);
     */
//    设置表名
    NSString* tableName = @"ID_employees";
//    设置表名行的标题
    NSString* creates = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ids text,username TEXT,fax TEXT,userId TEXT,departmentid TEXT, position TEXT, mobilePhone TEXT, telephone1 TEXT, telephone2 TEXT, extension TEXT, ciocaasUserID TEXT, email TEXT, flag TEXT, ctime TEXT )",tableName];
//    创建表的方法【创建数据库里的表】
    [db creatDatabase:creates];
    
//    读取数据库刚才创建的表
    NSString* ReadSql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    FMResultSet* resuetS = [db readSql:ReadSql];
    while ([resuetS next]) {
        NSLog(@"方法成功进入");
    }
    [db.datadb close];

    /*
    //管理器
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     */

//    取出保存的数据
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* _timestamp = [Defaults objectForKey:@"timestamp"];
//    设置参数
    /*
     open.ciopaas.com/Admin/Info/get_company_member?id=1&verify=Z3V2XZF0&eid=10000101&timestamp=1418374635

     */
    NSDictionary* dicts = @{@"id":_ids,@"verify":_verify,@"eid":_eid,@"timestamp":_timestamp};
    
//    发送企业员工的请求
    [manager GET:@"http://open.ciopaas.com/Admin/Info/get_company_member?" parameters:dicts success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"&&&&:员工:%@",operation.responseString);
        NSError* error = nil;
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {
            
        }else{
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
//              _enTerpriseID;// 企业标签ID
//              _employees;//企业员工departmentid 用来和企业标签进行判断的
#pragma mark   === [要进行判断的departmentid]
                _employees = model.departmentid;
                NSLog(@"Model.departmentid^^^^^^^^^:%@",_employees);
//                把取出的model保存到可变数组里
                [_detailsMutableArray addObject:model];
                
                Database* db = [Database sharDatabase];
                
                //从ID_Enterprise表里面读取_id列的值为model._ids的这一行的数据
                NSString* rearchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_employees",@"ids",model.ids];
                BOOL isExists = NO;
                if ([db.datadb open]) {
                    
//                    查询searchSql里的model.ids;
                    FMResultSet* result = [db.datadb executeQuery:rearchSql];
                    while ([result next]) {//便利表里的每一列
                        //查询到列里的：ids
                        NSString* ids = [result stringForColumn:@"ids"];
                        if ([ids isEqualToString:model.ids]) {
                            isExists = YES;
                            break;
                        }
                    }
                    [db.datadb close];
                }
                if (isExists) {//判断存在  此时isExists 为YES   【存在 就更新】
//                    更新要更新对应的参数
                    NSString* upDateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@',%@ = '%@', %@ ='%@',%@ = '%@' ,%@ = '%@',%@ = '%@' WHERE %@ = '%@'",@"ID_employees",model.username,model.fax,model.ids,model.userId,model.departmentid,model.position,model.mobilePhone,model.telephone1,model.telephone2,model.extension,model.ciocaasUserID,model.email,model.flag,model.ctimes];

                    
                    if ([db.datadb open]) {
                        
                        //更新updateSql表的内容
                        [db.datadb executeQuery:upDateSql];
                        [db.datadb close];
                    }
                }else{//没有找到就添加数据   【否则就添加数据】
//                    传要保存的参数
                    NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (username, fax, ids, userId,departmentid, position, mobilePhone, telephone1, telephone2, extension, ciocaasUserID, email, flag, ctime) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"ID_employees",model.username,model.fax,model.ids,model.userId,model.departmentid,model.position,model.mobilePhone,model.telephone1,model.telephone2,model.extension,model.ciocaasUserID,model.email,model.flag,model.ctimes];
                    //把数据保存到数据库的@"ID_Enterprise"表里
                    [db saveSql:inserSql];

                    
                }

            }
            
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"^^^^^^^get:%@",error);
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    _enTerpriseID   企业标签ID
    _employees      企业员工departmentid 用来和企业标签进行判断的*/

    NSLog(@"~~~~^^^^!!!:%@",_employees);
    NSLog(@"!!!&&&!!!:%@",_enTerpriseID);

    NSLog(@"SSDDFF:%ld",indexPath.section);
    if (indexPath.section == 0) {
        PopulationController* popu = [[PopulationController alloc]init];
//        [self.navigationController pushViewController:popu animated:YES];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:popu];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    if (indexPath.section == 1) {
        TextViewController* textvc = [[TextViewController alloc]init];
        UINavigationController* nacs = [[UINavigationController alloc]initWithRootViewController:textvc];
        [self.navigationController presentViewController:nacs animated:YES completion:nil];
    }

    
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
