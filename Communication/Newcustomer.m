//
//  Newcustomer.m
//  Communication
//
//  Created by CIO on 15/2/10.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Newcustomer.h"
#import "PublicAction.h"
#import "CusInfoCell.h"
#import "CustomerController.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "CusMarkViewController.h"
#import "FMDatabase.h"
@interface Newcustomer ()

@end

@implementation Newcustomer
@synthesize model;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"添加客户";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;
        
        UIBarButtonItem * leftBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonreturn:)];
        leftBtn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=leftBtn;
        
        UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonreturn:)];
        rightBtn.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=rightBtn;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
    CusInfoCell * tableCell=(CusInfoCell*)[_tableview cellForRowAtIndexPath:indexPath];
    if (model.cid!=nil&&![model.cid isEqual:[NSNull null]]&&![model.cid isEqualToString:@""]&&![model.cid isEqualToString:@"0"])
    {
        //循环创建标签lable
        NSArray * cids=[model.cid componentsSeparatedByString:@","];
        NSDictionary * dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"admin标签",@"意向客户",@"产品客户", nil] forKeys:[NSArray arrayWithObjects:@"128",@"98",@"188", nil]];
        for (int i=0;i<cids.count;i++)
        {
            NSString *str=[cids objectAtIndex:i];
            UILabel * btn=[[UILabel alloc]initWithFrame:CGRectMake(tableCell._textLabel.frame.origin.x+tableCell._textLabel.frame.size.width+65*i,10,55,20)];
            btn.text=[dict objectForKey:str];
            btn.font=[UIFont systemFontOfSize:12];
            btn.textAlignment=NSTextAlignmentCenter;
            btn.layer.borderColor = [COLOR(35.0, 152.0, 217.0, 1) CGColor];
            btn.layer.borderWidth = 1.0;
            btn.textColor=COLOR(35.0, 152.0, 217.0, 1);
            btn.layer.cornerRadius=10;
            [tableCell.contentView addSubview:btn];
        }
    }else
    {
        UILabel * btn=[[UILabel alloc]initWithFrame:CGRectMake(tableCell._textLabel.frame.origin.x+tableCell._textLabel.frame.size.width+10,8,65,20)];
        btn.text=@"我的通讯录";
        btn.font=[UIFont systemFontOfSize:12];
        btn.textAlignment=NSTextAlignmentCenter;
        btn.layer.borderColor = [COLOR(35.0, 152.0, 217.0, 1) CGColor];
        btn.layer.borderWidth = 1.0;
        btn.textColor=COLOR(35.0, 152.0, 217.0, 1);
        btn.layer.cornerRadius=10;
        [tableCell.contentView addSubview:btn];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CusInfoCell *cell =(CusInfoCell *) [_tableview  cellForRowAtIndexPath:indexPath];
    [cell._tetLabel becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    [self loadDataSource];
}

-(void)loadDataSource
{
    if (dataArray==nil) {
        dataArray=[NSMutableArray arrayWithCapacity:2];
    }
    NSArray * Heard=[[NSArray alloc]initWithObjects:@"a姓名", nil];
    NSArray * foot=[[NSArray alloc]initWithObjects:@"a公司",@"b标签",@"c手机",@"d电话",@"e邮箱",@"f地址", nil];
    [dataArray addObject:Heard];
    [dataArray addObject:foot];

    keys=[NSArray arrayWithObjects:@"name",@"company",@"cid",@"mobilePhone",@"telephone1",@"email",@"address", nil];
}

-(void)drawView
{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
     _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableview];
    [PublicAction tableViewCenter:_tableview];
    [_tableview setTableFooterView:[UIView new]];
}


-(void)rightButtonreturn:(UIBarButtonItem *)right
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    if (![self checkInput]) {
        return;
    }else
    {
        int rowid=[self saveCustomerToLocal];
        if (rowid!=0) {
            [self saveCustomerWithUrl:rowid];
        }
    }
}

-(NSString *)strResult:(NSString *)str
{
    if (str==nil||[str isEqual:[NSNull null]]) {
        return @"";
    }
    return str;
}


-(BOOL)checkInput
{
    NSString * name=[model.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * telephone=[model.mobilePhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    UIWindow *win=[[UIApplication sharedApplication].windows objectAtIndex:1];
    if (name.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        hud.labelText = @"姓名不能为空";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CusInfoCell *cell =(CusInfoCell *) [_tableview  cellForRowAtIndexPath:indexPath];
        [cell._tetLabel becomeFirstResponder];
        return false;
    }
    if (telephone.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        hud.labelText = @"手机不能为空";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        CusInfoCell *cell =(CusInfoCell *) [_tableview  cellForRowAtIndexPath:indexPath];
        [cell._tetLabel becomeFirstResponder];
        return false;
    }
    return  true;
}


-(int)saveCustomerToLocal
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (address,fax,userId,department, birthday, mobilePhone, telephone1, telephone2, cid, company, email, cshare, ctime, groupname , industry, internet, job, name, password, pid, pshare , remark , status,uid,sign) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"ID_Customer",model.address,model.fax,model.userId,model.department,model.birthday,model.mobilePhone,model.telephone1,model.telephone2,model.cid,model.company,model.email,model.cshare,model.ctime,model.groupname,model.industry,model.internet,model.job,model.name,model.password,model.pid,model.pshare,model.remark,model.status,model.uid,model._id];
        //把数据保存到数据库的@"ID_Enterprise"表里
        BOOL result= [db executeUpdate:inserSql];
        if (result) {
            NSString * sql=@"SELECT last_insert_rowid() from ID_CUSTOMER";
            FMResultSet * resultSet=[db executeQuery:sql];
            if ([resultSet next])
            {
                int rowid=[resultSet intForColumnIndex:0];
                [db close];
                if (_status==1) {
                    [PublicAction changeContactType:[NSDictionary dictionaryWithObjectsAndKeys:@"客户",model._id, nil]];
                }
                [self showMessage];
                return rowid;
            }
        }
    }
    [db close];
    return 0;
}

-(void)showMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    [hud hide:YES afterDelay:1];
    hud.labelText = @"添加客户成功!";
    [self.navigationController.view addSubview:hud];
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    if (_status==1)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
    }else
    {
        CustomerController * customer=[self.navigationController.viewControllers objectAtIndex:index-1];
        customer.cusModel=model;
        customer.optionStatus=1;
        [self.navigationController popToViewController:customer animated:YES];
    }
}

-(NSString *)getResult:(NSString *)str
{
    if (str==nil||[str isEqual:[NSNull null]]) {
        return @"";
    }
    return str;
}

-(BOOL)updateCustomerLocalID:(CustomerModel*)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString * sql=[NSString stringWithFormat:@"UPDATE %@ SET _id='%@', address='%@',fax='%@',department='%@', birthday='%@', mobilePhone='%@', telephone1='%@', telephone2='%@', cid='%@', company='%@', email='%@', cshare='%@', industry='%@', internet='%@', job='%@', name='%@',remark='%@' WHERE sysid= %@",@"ID_Customer",[self getResult:sender._id],[self getResult:sender.address],[self getResult:sender.fax],[self getResult:sender.department],[self getResult:sender.birthday],[self getResult:sender.mobilePhone],[self getResult:sender.telephone1],[self getResult:sender.telephone2],[self getResult:sender.cid],[self getResult:sender.company],[self getResult:sender.email],[self getResult:sender.cshare],[self getResult:sender.industry],[self getResult:sender.internet],[self getResult:sender.job],[self getResult:sender.name],[self getResult:sender.remark],sender.sysid];
        if ([db executeUpdate:sql]) {
            [db close];
            return true;
        }
    }
    [db close];
    return false;
}

-(void)saveCustomerWithUrl:(int)rowid
{
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* userid = [Defaults objectForKey:@"userid"];
    NSDictionary * telDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self strResult:model.name],[self strResult:model.company],[self strResult:model.cid],[self strResult:model.mobilePhone],[self strResult:model.telephone1],[self strResult:model.email],[self strResult:model.address],userid,[NSString stringWithFormat:@"%d",rowid], nil] forKeys:[NSArray arrayWithObjects:@"name",@"company",@"cid",@"mobilePhone",@"telephone1",@"email",@"address",@"follower",@"sysID", nil]];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/insert_customer_data?id=%@&userid=%@&eid=%@&verify=%@&customerdata=%@",_ids,userid,_eid,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (error==NULL) {
        if (dic) {
            NSArray * array=[dic objectForKey:@"insert_result"];
            NSDictionary * dataDict= [array objectAtIndex:0];
            model._id=[dataDict objectForKey:@"newID"];
            model.sysid=[NSString stringWithFormat:@"%d",rowid];
            [self updateCustomerLocalID:model];
        }
    }
}

-(void)leftButtonreturn:(UIBarButtonItem*)left{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[dataArray objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"cell";
    CusInfoCell* tableCell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell == nil) {
        tableCell = [[CusInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell];
    }
    if (indexPath.section!=1||indexPath.row!=1) {
        tableCell._tetLabel.enabled=YES;
    }
    if (indexPath.section==1&&(indexPath.row==2||indexPath.row==3)) {
        tableCell._tetLabel.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    }
    NSArray * arr=[[dataArray objectAtIndex:indexPath.section] sortedArrayUsingSelector:@selector(compare:)];
    NSString * value=[arr objectAtIndex:indexPath.row];
    tableCell.title=[value substringFromIndex:1];
    tableCell._tetLabel.tag=indexPath.section+indexPath.row;
    if (tableCell._tetLabel.tag==0) {
        tableCell._tetLabel.text=model.name;
    }else if(tableCell._tetLabel.tag==3)
    {
        tableCell._tetLabel.text=model.mobilePhone;
    }else if(tableCell._tetLabel.tag==4)
    {
        tableCell._tetLabel.text=model.telephone1;
    }
    [tableCell._tetLabel addTarget:self action:@selector(inputTap:) forControlEvents:UIControlEventEditingDidEnd];
    return tableCell;
}

-(void)inputTap:(UITextField *)sender
{
    NSInteger num=[sender tag];
    if (model==nil) {
        model=[[CustomerModel alloc]init];
    }
    [model setValue:sender.text forKey:keys[num]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1||indexPath.row==1)
    {
        CusMarkViewController * cus=[[CusMarkViewController alloc]init];
        cus.cid=model.cid;
        [self.navigationController pushViewController:cus animated:YES];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
