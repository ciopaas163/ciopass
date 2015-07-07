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


@interface CustomerController ()

@end

@implementation CustomerController
-(void)setModel:(CuclabelModel *)model{
    if (_model!=model) {
        _model = model;
//        _textLabel.text = model.groupname;

        NSLog(@"model.groupname%@",model.groupname);

    }
}

-(void)viewWillAppear:(BOOL)animated{

    [self getCustomerURL];//网络请求
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"客户通讯录";

    _mutableArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UITabBarSystemItemRecents target:self action:@selector(rightBarButton:)];


    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 48 - searchBar.frame.size.height )];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    [self.view addSubview:_tableView];
//    调用移除清除UITableView底部多余的分割线
    [self setExtraCellLineHidden:_tableView];


}
#pragma mark === 【rightBarButton 】
-(void)rightBarButton:(UIBarButtonItem*)rihgt{
    NSLog(@"设置");
    Newcustomer* newcust = [[Newcustomer alloc] init];
    [self.navigationController pushViewController:newcust animated:YES];
}

#pragma mark  = [UITableView]
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger counts = _mutableArray.count;
    NSLog(@"sasasda:%ld",(long)counts);
    return counts;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 5;
}
/*
//UITableView 头标的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}
  */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"Cell";
    CustomerCell * tableCell =[tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell == nil) {
        tableCell = [[CustomerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    
    if (_mutableArray.count) {
        tableCell.model = [_mutableArray objectAtIndex:indexPath.section];
    }

    return tableCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
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

#pragma mark  === [网络请求  -- 客户通讯录]
-(void)getCustomerURL{

#pragma mark ====【 保存到本地数据库   == 客户 】

    Database * db = [Database sharDatabase];
    NSLog(@"数据DB:%@",db);
    //    设置表名：
    NSString* TableName = @"ID_Customer";
    //    设置表名的标题
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id text, uid TEXT, groupname TEXT, pid TEXT, ctime TEXT)",TableName];

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
    AFHTTPRequestOperationManager* Manager = [AFHTTPRequestOperationManager manager];
    Manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    //取出保存的数据
    NSString *_id = [defaults objectForKey:@"nid"];
    NSString* eid = [defaults objectForKey:@"eid"];
    NSString* verify = [defaults objectForKey:@"verify"];
    NSString* auchCode = [defaults objectForKey:@"auchCode"];
    NSString* timestamp = [defaults objectForKey:@"timestamp"];
    NSLog(@"_id:%@,eid:%@,verify:%@,auchCode:%@,timestamp:%@",_id,eid,verify,auchCode,timestamp);



    NSDictionary* dicts = @{@"id":_id,@"verify":verify,@"eid":eid,@"auchCode":auchCode,@"timestamp":timestamp};
    //    发送请求
    [Manager GET:@"http://open.ciopaas.com/Admin/Info/get_company_customer_groups?" parameters:dicts success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"###:get:%@",operation.responseString);

        NSError* error = nil;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {

        }else{
            NSMutableArray* array = [NSMutableArray array];
            NSArray* customer = [dict objectForKey:@"customergroupslist"];
            for (NSDictionary *content in customer) {
                CusModel *model = [[CusModel alloc] init];
                model._id = [content objectForKey:@"id"];
                model.pid = [content objectForKey:@"pid"];
                model.groupname = [content objectForKey:@"groupname"];
                model.uid = [content objectForKey:@"uid"];
                model.ctime = [content objectForKey:@"ctime"];
                
                [_mutableArray addObject:model];

                NSLog(@"_mutableArray:%ld",(unsigned long)_mutableArray.count);

                Database *db = [Database sharDatabase];
                //从ID_Customer表里面读取_id列的值为model._id的这一行的数据
                NSString* searchSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",@"ID_Customer",@"_id",model._id];
//                判断
                BOOL isExists = NO;
                if ([db.datadb open]) {
//                从表里查找model._id
                    FMResultSet* reselt = [db.datadb executeQuery:searchSql];
                    while ([reselt next]) {//遍历这个表reselt的每一列
//                        查询到列里的:_id
                        NSString* _id = [reselt stringForColumn:@"_id"];
                        if ([_id isEqualToString:model._id]) {
                            isExists = YES;
                            break;
                        }
                    }
                    [db.datadb close];//关闭表
                }
                if (isExists) { //判断存在  此时isExists 为YES   【存在 就更新】
                    NSString* updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@',%@ = '%@',%@ = '%@', %@= '%@' WHERE %@ = '%@'",@"ID_Customer",@"_id",model._id,@"uid",model.uid,@"pid",model.pid,@"groupname",model.groupname,@"ctime",model.ctime];
                    if ([db.datadb open]) {
                        [db.datadb executeQuery:updateSQL];//更新updateSql表的内容
                        [db.datadb close];

                    }
                }else{//否则就添加数据
                    NSString* inserSQL = [NSString stringWithFormat:@"INSERT INTO %@ (_id , pid , uid ,groupname , ctime) VALUES ('%@','%@','%@','%@','%@')",@"ID_Customer",model._id,model.pid,model.uid,model.groupname,model.ctime];

                    //把数据保存到数据库的@"ID_Customer"表里
                    [db saveSql:inserSQL];
                    NSLog(@"&&&&&&:%@",inserSQL);
                }

            }
            [_tableView reloadData];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%%QQQQ:get%@",error);

    }];


    
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
