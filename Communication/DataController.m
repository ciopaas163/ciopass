//
//  DataController.m
//  Communication
//
//  Created by CIO on 15/1/30.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "DataController.h"
//#import "DataCell.h"

#import "AFNetworking.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height

@interface DataController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableData *data_;
    
    NSMutableArray *_titleArray;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_manArray;
    NSString *urlstr;
    
    NSString *name;
    NSString *company_name;
    NSString *sex;   //性别
    NSString *mobilePhone;//手机
    NSString *email;//邮箱
    NSString *telephone1;//电话1
    NSString *telephone2;//电话2
    NSString *flag;//部门
    NSString *job;//职位
    
    NSString *industry;//行业
    NSString *internet;//地址
    NSString *address;//地址
    NSString *fax;//传真

    
    UITextField* textField;
    UIButton *button;
}

@property (nonatomic, assign) BOOL btnStatus; // 状态标识
@end

@implementation DataController

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    //导航栏
    self.title = @"我的资料";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick:)];
    leftButton.tag = 40;
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
//    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    self.btnStatus = YES;
    [button addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self get2];

    //数据初始化
//  
    _dataArray = [NSMutableArray array];
    _manArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.view addSubview:_tableView];
    
    _titleArray =[NSMutableArray arrayWithObjects:@"性别",@"手机",@"邮箱",@"电话1",@"电话2",@"部门 ",@"职位",@"行业",@"网址",@"传真",nil];

   
}

-(void)get2
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nid = [userDefaults objectForKey:@"nid"];
    NSString *verify = [userDefaults objectForKey:@"verify"];
    
    urlstr = [NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/get_personal_data?id=%@&verify=%@",nid,verify];
    
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //json解析数据
         
         NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         
         NSDictionary *XinArray = Dic[@"personal_data"][0];
         
         name = [NSString stringWithFormat:@"%@",XinArray[@"name"]];
         
         
         company_name = [NSString stringWithFormat:@"%@",XinArray[@"company_name"]];
         
         sex = [NSString stringWithFormat:@"%@",XinArray[@"sex"]];   //性别
         mobilePhone = [NSString stringWithFormat:@"%@",XinArray[@"mobilePhone"]];//手机
         email = [NSString stringWithFormat:@"%@",XinArray[@"email"]];//邮箱
         telephone1 = [NSString stringWithFormat:@"%@",XinArray[@"telephone1"]];//电话1
         telephone2 = [NSString stringWithFormat:@"%@",XinArray[@"telephone2"]];//电话2
         flag = [NSString stringWithFormat:@"%@",XinArray[@"flag"]];//部门
         job = [NSString stringWithFormat:@"%@",XinArray[@"job"]];//职位
         
         industry = [NSString stringWithFormat:@"%@",XinArray[@"industry"]];//行业
         internet = [NSString stringWithFormat:@"%@",XinArray[@"internet"]];//地址
         address = [NSString stringWithFormat:@"%@",XinArray[@"address"]];//地址
         fax = [NSString stringWithFormat:@"%@",XinArray[@"fax"]];//传真
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];

}

-(void)editButtonClick:(UIButton *)but
{
    
 
    if (self.btnStatus == YES) {
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        textField.userInteractionEnabled = NO;
    }
    else{
        [button setTitle:@"保存" forState:UIControlStateNormal];
    }
    
    self.btnStatus = !self.btnStatus;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        return [_titleArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *IDCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    }
    textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 2, self.view.frame.size.width - 45 * 2, 40 - 2*2)];
    //    textField.borderStyle = UITextBorderStyleLine;
    textField.delegate = self;
//    textField.userInteractionEnabled = NO;

    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text = @"姓名";
            textField.text = name;
            [cell.contentView addSubview:textField];
        }
        else
        {
            cell.textLabel.text = @"公司";
            textField.text = company_name;
            [cell.contentView addSubview:textField];

        }
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_titleArray[indexPath.row]];
        [cell.contentView addSubview:textField];
        if (indexPath.row==1) {
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            textField.text = _dataArray[indexPath.row];
        }

    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 返回
-(void)leftButtonClick:(UIButton*)backButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 编辑
-(void)rightButtonClick:(UIButton *)editButton
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

 
 //网络请求数据方法
 -(void)get
 {
 
 
 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 NSString *nid = [userDefaults objectForKey:@"nid"];
 NSString *verify = [userDefaults objectForKey:@"verify"];
 
 urlStr = [NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/get_personal_data?id=%@&verify=%@",nid,verify];
 
 AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
 manager.responseSerializer=[AFHTTPResponseSerializer serializer];
 [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
 {
 //json解析数据
 
 NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
 
 NSDictionary *XinArray = Dic[@"personal_data"][0];
 
 name = [NSString stringWithFormat:@"%@",XinArray[@"name"]];
 
 NSLog(@"XinArray2 = %@",name);
 company_name = [NSString stringWithFormat:@"%@",XinArray[@"company_name"]];
 
 NSLog(@"XinArray3 = %@",company_name);
 
 //              _manArray = [NSMutableArray arrayWithObjects:name,company_name, nil];
 
 //         NSString *sex = [NSString stringWithFormat:@"%@",XinArray[@"sex"]];
 //         NSString *mobilePhone = [NSString stringWithFormat:@"%@",XinArray[@"mobilePhone"]];
 //         NSString *email = [NSString stringWithFormat:@"%@",XinArray[@"email"]];
 //         NSString *telephone1 = [NSString stringWithFormat:@"%@",XinArray[@"telephone1"]];
 //         NSString *telephone2 = [NSString stringWithFormat:@"%@",XinArray[@"telephone2"]];
 //         NSString *flag = [NSString stringWithFormat:@"%@",XinArray[@"flag"]];
 //         NSString *job = [NSString stringWithFormat:@"%@",XinArray[@"job"]];
 //         NSString *industry = [NSString stringWithFormat:@"%@",XinArray[@"industry"]];
 //         NSString *internet = [NSString stringWithFormat:@"%@",XinArray[@"internet"]];
 //         NSString *address = [NSString stringWithFormat:@"%@",XinArray[@"address"]];
 //         NSString *fax = [NSString stringWithFormat:@"%@",XinArray[@"fax"]];
 
 NSMutableArray* aa = [NSMutableArray array];
 [aa addObject:name];
 _manArray = aa;
 //             [_manArray addObject:name];         //姓名
 //             [_manArray addObject:company_name]; //公司
 
 
 NSLog(@"_dataArray = %@",_manArray);
 
 
 [_dataArray addObject:XinArray[@"sex"]];         //性别
 [_dataArray addObject:XinArray[@"mobilePhone"]]; //手机
 [_dataArray addObject:XinArray[@"email"]];       //邮箱
 [_dataArray addObject:XinArray[@"telephone1"]];  //电话1
 [_dataArray addObject:XinArray[@"telephone2"]];  //电话2
 [_dataArray addObject:XinArray[@"flag"]];    //部门
 [_dataArray addObject:XinArray[@"job"]];     //职位
 [_dataArray addObject:XinArray[@"industry"]];//行业
 [_dataArray addObject:XinArray[@"internet"]];//网址
 [_dataArray addObject:XinArray[@"address"]]; //地址
 [_dataArray addObject:XinArray[@"fax"]];     //传真
 //         }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"12212 = %@",error);
 }];
 
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
    [titleButton setText:@"我的资料"];
    [navigationbarView addSubview:titleButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:backButton];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREENWIDTH/6*5,12, 40, 20)];
    [addButton setTitle:@"保存"  forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:addButton];
    
    
}
*/
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
