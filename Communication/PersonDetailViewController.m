//
//  PersonDetailViewController.m
//  Communication
//
//  Created by helloworld on 15/7/23.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "IphoneController.h"
#import "PublicAction.h"
#import "CusInfoCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CusModel.h"
#import "Header.h"
#import "FMDatabase.h"
#import "PersonalViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
@implementation PersonDetailViewController

@synthesize model;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"联系人资料";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;
        
        UIBarButtonItem * btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        btn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=btn;
        
        UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
        rightBtn.tag=1;
        rightBtn.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=rightBtn;
    }
    return self;
}

-(void)rightAction:(UIBarButtonItem*)sender
{
    NSInteger tag= [sender tag];
    if (tag==1) {
        [sender setTitle:@"保存"];
        sender.tag=2;self.optionStatus=1;
        [dataArray removeObjectAtIndex:1];
        [dictAll removeObjectForKey:@"g收起更多"];
        [dataArray insertObject:dictAll atIndex:1];
        [_tableview reloadData];
    }else
    {
        [dictAll setValue:@"" forKey:@"g收起更多"];
        [sender setTitle:@"编辑"];
        sender.tag=1;self.optionStatus=0;
        [dataArray removeObjectAtIndex:1];
        [dataArray insertObject:dictOther atIndex:1];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
        [firstResponder resignFirstResponder];
        if (isChange) {
            if ([self updateContactLocalID:model]) {
                [self saveContactWithUrl];
            }
        }
        
        [_tableview reloadData];
    }
    
}

-(BOOL)updateContactLocalID:(PersonInfoModel*)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString * sql=[NSString stringWithFormat:@"UPDATE %@ SET _id='%@', address='%@',fax='%@',department='%@', birthday='%@', mobilePhone='%@', telephone1='%@', telephone2='%@', cid='%@', company='%@', email='%@', industry='%@', internet='%@', job='%@', name='%@',remark='%@',cus_type='%ld' WHERE _id= %@",@"ID_Usercontact",[self getResult:sender._id],[self getResult:sender.address],[self getResult:sender.fax],[self getResult:sender.department],[self getResult:sender.birthday],[self getResult:sender.mobilePhone],[self getResult:sender.telephone1],[self getResult:sender.telephone2],[self getResult:sender.cid],[self getResult:sender.company],[self getResult:sender.email],[self getResult:sender.industry],[self getResult:sender.internet],[self getResult:sender.job],[self getResult:sender.name],[self getResult:sender.remark],sender.cus_type,sender._id];
        if ([db executeUpdate:sql]) {
            [db close];
            return true;
        }
    }
    [db close];
    return false;
}

-(void)saveContactWithUrl
{
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* userid = [Defaults objectForKey:@"userid"];
    NSDictionary * telDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self getResult:model.name],[self getResult:model.company],[self getResult:model.cid],[self getResult:model.mobilePhone],[self getResult:model.telephone1],[self getResult:model.telephone2],[self getResult:model.email],[self getResult:model.department],[self getResult:model.birthday],[self getResult:model.job],[self getResult:model.industry],[self getResult:model.address],[self getResult:model.fax],[self getResult:model.remark],userid,[self getResult:model._id], nil] forKeys:[NSArray arrayWithObjects:@"name",@"company",@"cid",@"mobilePhone",@"telephone1",@"telephone2",@"email",@"department",@"birthday",@"job",@"industry",@"address",@"fax",@"remark",@"userID",@"id", nil]];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/update_personal_addressbook?id=%@&verify=%@&addressbook=%@",_ids,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (error==NULL) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        [hud hide:YES afterDelay:1];
        hud.labelText = @"修改客户资料成功!";
        [self.navigationController.view addSubview:hud];
    }
}

-(void)inputTap:(UITextField *)sender
{
    NSInteger num=[sender tag];
    if (num>1) {
        num++;
    }
    if (model==nil) {
        model=[[PersonInfoModel alloc]init];
    }
    if (![[model valueForKey:keys[num]] isEqualToString:sender.text]) {
        isChange=YES;
    }
    [model setValue:sender.text forKey:keys[num]];
}

-(void)back
{
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
    [_tableview reloadData];
}

-(NSString *)getResult:(NSString *)str
{
    if (str==nil||[str isEqual:[NSNull null]]||[str isEqualToString:@"<null>"]||[str isEqualToString:@"(null)"]) {
        return @"";
    }
    return str;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (dataArray==nil) {
        dataArray=[NSMutableArray arrayWithCapacity:2];
    }else
    {
        [dataArray removeAllObjects];
    }
    dictHeard=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self getResult:model.name],[self getResult:model.company], nil] forKeys:[NSArray arrayWithObjects:@"a姓名",@"b公司", nil]];
    
    dictAll=[[NSMutableDictionary alloc]initWithCapacity:20];
    [dictAll setValue:[self getResult:model.cid] forKey:@"a标签"];
    [dictAll setValue:[self getResult:model.mobilePhone] forKey:@"c手机"];
    [dictAll setValue:[self getResult:model.telephone1] forKey:@"d电话1"];
    [dictAll setValue:[self getResult:model.telephone2] forKey:@"e电话2"];
    [dictAll setValue:[self getResult:model.email] forKey:@"f邮箱"];
    [dictAll setValue:@"" forKey:@"g收起更多"];
    [dictAll setValue:[self getResult:model.department] forKey:@"h部门"];
    [dictAll setValue:[self getResult:model.birthday] forKey:@"i生日"];
    [dictAll setValue:[self getResult:model.job] forKey:@"j职位"];
    [dictAll setValue:[self getResult:model.industry] forKey:@"k行业"];
    [dictAll setValue:@"" forKey:@"l网址"];
    [dictAll setValue:[self getResult:model.address] forKey:@"m地址"];
    [dictAll setValue:[self getResult:model.fax] forKey:@"n传真"];
    [dictAll setValue:[self getResult:model.remark] forKey:@"o备注"];
    dictOther=[[NSMutableDictionary alloc]initWithCapacity:10];
    [dictOther setValue:[self getResult:model.cid] forKey:@"a标签"];
    [dictOther setValue:[self getResult:model.mobilePhone] forKey:@"c手机"];
    [dictOther setValue:[self getResult:model.telephone1] forKey:@"d电话1"];
    [dictOther setValue:[self getResult:model.telephone2] forKey:@"e电话2"];
    [dictOther setValue:[self getResult:model.email] forKey:@"f邮箱"];
    [dictOther setValue:@"" forKey:@"g查看更多"];
    [dataArray addObject:dictHeard];
    [dataArray addObject:dictOther];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isChange=NO;
    keys=[NSArray arrayWithObjects:@"name",@"company",@"cid",@"mobilePhone",@"telephone1",@"telephone2",@"email",@"department",@"birthday",@"job",@"industry",@"internet",@"address",@"fax",@"remark", nil];
    self.view.backgroundColor=[UIColor whiteColor];
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.contentSize = CGSizeMake(0, _tableview.bounds.size.height);
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    showStatus=NO;
    [PublicAction tableViewCenter:_tableview];
    [_tableview setTableFooterView:[UIView new]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    markDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    for (CusModel *m in self._mutableArray)
    {
        if (![m._id isEqualToString:@"-1"])
            [markDict setValue:m.groupname forKey:m._id];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return 1;
    }
    return [[dataArray objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 120;
    }
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"cell";
    CusInfoCell* tableCell = [tableView dequeueReusableCellWithIdentifier:Cell];
    NSInteger rigthBtnTag=self.navigationItem.rightBarButtonItem.tag;
    if (tableCell == nil) {
        tableCell = [[CusInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell];
    }
    if (indexPath.section==2)
    {
        static NSString* Ce = @"mycell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Ce];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Ce];
        }
        if (recordBtn==nil) {
            recordBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,30)];
            [recordBtn setTitle:@"查看记录" forState:UIControlStateNormal];
            [recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            recordBtn.layer.backgroundColor=[UIColor whiteColor].CGColor;
            [recordBtn addTarget:self action:@selector(recordTap) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:recordBtn];
            float origin=35;
            if (model.cus_type==0) {
                addBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,origin,self.view.frame.size.width,30)];
                [addBtn setTitle:@"加入客户" forState:UIControlStateNormal];
                [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                addBtn.layer.backgroundColor=[UIColor whiteColor].CGColor;
                [addBtn addTarget:self action:@selector(addCustomer:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:addBtn];
                origin+=35;
            }
            
            deleteCus=[[UIButton alloc]initWithFrame:CGRectMake(0,origin,self.view.frame.size.width,30)];
            [deleteCus setTitle:@"删除" forState:UIControlStateNormal];
            [deleteCus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            deleteCus.layer.backgroundColor=COLOR(220,20,60,1).CGColor;
            [deleteCus addTarget:self action:@selector(deleteTap) forControlEvents:UIControlEventEditingDidEnd];
            [cell.contentView addSubview:deleteCus];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    NSDictionary * dict=[dataArray objectAtIndex:indexPath.section];
    NSString * key=[[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.row];
    NSString * value=[dict objectForKey:key];
    tableCell.title=[key substringFromIndex:1];
    tableCell.subtitle=value;
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            tableCell._tetLabel.hidden=YES;
            if (![value isEqualToString:@"0"]&&value.length>0)
            {
                //循环创建标签lable
                NSArray * cids=[model.cid componentsSeparatedByString:@","];
                for (int i=0;i<cids.count;i++)
                {
                    NSString *str=[cids objectAtIndex:i];
                    float width=tableCell._textLabel.frame.origin.x+tableCell._textLabel.frame.size.width+10;
                    if (i!=0)
                    {
                        UIView * v=[tableCell.contentView viewWithTag:i-1+200];
                        width=v.frame.origin.x+v.frame.size.width+10;
                    }

                    UILabel * btn=[[UILabel alloc]initWithFrame:CGRectMake(width,10,[[markDict objectForKey:str] length]*20,20)];
                    btn.text=[markDict objectForKey:str];
                    btn.font=[UIFont systemFontOfSize:12];
                    btn.textAlignment=NSTextAlignmentCenter;
                    btn.layer.borderColor = [COLOR(35.0, 152.0, 217.0, 1) CGColor];
                    btn.layer.borderWidth = 1.0;
                    btn.textColor=COLOR(35.0, 152.0, 217.0, 1);
                    btn.layer.cornerRadius=10;
                    btn.tag=i+200;
                    [tableCell.contentView addSubview:btn];
                }
            }
        }else if (indexPath.row==5&&rigthBtnTag==1)
        {
            static NSString* click = @"click";
            CusInfoCell* clickcell = [tableView dequeueReusableCellWithIdentifier:click];
            if (clickcell == nil) {
                clickcell = [[CusInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:click];
            }
            clickcell.title=[key substringFromIndex:1];

            if (imageClose==nil)
            {
                imageClose=[[UIImageView alloc]initWithFrame:CGRectMake(tableCell.frame.size.width-25, 12.5, 20, 15)];
                imageClose.image=[UIImage imageNamed:@"sub_page_close.png"];
                [clickcell.contentView addSubview:imageClose];
            }
            if (self.optionStatus!=1) {
                imageClose.hidden=NO;
            }else
            {
                imageClose.hidden=YES;
            }
            clickcell._tetLabel.tag=indexPath.section+indexPath.row;
            return clickcell;
            
        }else
        {
            static NSString* num = @"number";
            CusInfoCell* numbercell = [tableView dequeueReusableCellWithIdentifier:num];
            if (numbercell == nil) {
                numbercell = [[CusInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:num];
            }
            numbercell.title=[key substringFromIndex:1];
            numbercell.subtitle=value;
            if (indexPath.row==1&&value.length>0)
            {
                numbercell._telImage.hidden=NO;
            }else if(indexPath.row==2&&value.length>0)
            {
                numbercell._telImage.hidden=NO;
            }else if(indexPath.row==3&&value.length>0)
            {
                numbercell._telImage.hidden=NO;
            }else
            {
                numbercell._telImage.hidden=YES;
            }
            if (indexPath.row==1||indexPath.row==2||indexPath.row==3) {
                numbercell._tetLabel.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
            }else
            {
                numbercell._tetLabel.keyboardType=UIKeyboardTypeDefault;
            }
            if (rigthBtnTag==2) {
                numbercell._tetLabel.enabled=YES;
                numbercell._tetLabel.delegate=self;
            }else
            {
                numbercell._tetLabel.enabled=NO;
            }
            numbercell.telphoneNum=value;
            numbercell._tetLabel.tag=indexPath.section+indexPath.row;
            [numbercell._tetLabel addTarget:self action:@selector(inputTap:) forControlEvents:UIControlEventValueChanged];
            return numbercell;
        }
    }
    if (rigthBtnTag==2) {
        tableCell._tetLabel.enabled=YES;
        tableCell._tetLabel.delegate=self;
    }else
    {
        tableCell._tetLabel.enabled=NO;
    }
    [tableCell._tetLabel addTarget:self action:@selector(inputTap:) forControlEvents:UIControlEventValueChanged];
    tableCell._tetLabel.tag=indexPath.section+indexPath.row;
    return tableCell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1&&indexPath.row==5)
    {
        if (!showStatus)
        {
            showStatus=YES;
            [dataArray removeObjectAtIndex:1];
            imageClose.image=[UIImage imageNamed:@"sub_page_open.png"];
            [dataArray insertObject:dictAll atIndex:1];
        }else
        {
            showStatus=NO;
            [dataArray removeObjectAtIndex:1];
            imageClose.image=[UIImage imageNamed:@"sub_page_close.png"];
            [dataArray insertObject:dictOther atIndex:1];
        }
        [_tableview reloadData];
    }
    [_tableview deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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

#pragma  mark self action

-(BOOL)deleteContactInLocal
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    NSString * sql=[NSString stringWithFormat:@"delete from ID_Usercontact where _id='%@'",model._id];
    if ([db open]) {
        if ([db executeUpdate:sql]) {
            [db close];
            return true;
        }
    }
    [db close];
    return false;
}

-(void)recordTap
{
}
-(void)addCustomer:(UIButton *)sender
{
    int rowid= [self saveCustomerToLocal];
    if (rowid!=0)
    {
        deleteCus.frame=sender.frame;
        [sender removeFromSuperview];
        [self saveCustomerWithUrl:rowid];
        model.cus_type=1;
        [self updateContactLocalID:model];
        [_tableview reloadData];
    }
}

-(int)saveCustomerToLocal
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (address,fax,department, birthday, mobilePhone, telephone1, telephone2, cid, company, email, ctime , industry, internet, job, name, password, pid,remark , status,uid) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"ID_Customer",model.address,model.fax,model.department,model.birthday,model.mobilePhone,model.telephone1,model.telephone2,model.cid,model.company,model.email,model.ctime,model.industry,model.internet,model.job,model.name,model.password,model.pid,model.remark,model.status,model.uid];
        //把数据保存到数据库的@"ID_Enterprise"表里
        BOOL result= [db executeUpdate:inserSql];
        if (result) {
            NSString * sql=@"SELECT last_insert_rowid() from ID_CUSTOMER";
            FMResultSet * resultSet=[db executeQuery:sql];
            if ([resultSet next])
            {
                int rowid=[resultSet intForColumnIndex:0];
                [db close];
                return rowid;
            }
        }
    }
    [db close];
    return 0;
}

-(void)saveCustomerWithUrl:(int)rowid
{
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* userid = [Defaults objectForKey:@"userid"];
    NSDictionary * telDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self getResult:model.name],[self getResult:model.company],[self getResult:model.cid],[self getResult:model.mobilePhone],[self getResult:model.telephone1],[self getResult:model.email],[self getResult:model.address],userid,[NSString stringWithFormat:@"%d",rowid], nil] forKeys:[NSArray arrayWithObjects:@"name",@"company",@"cid",@"mobilePhone",@"telephone1",@"email",@"address",@"follower",@"sysID", nil]];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/insert_customer_data?id=%@&userid=%@&eid=%@&verify=%@&customerdata=%@",_ids,userid,_eid,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dic) {
        NSArray * array=[dic objectForKey:@"insert_result"];
        NSDictionary * dataDict= [array objectAtIndex:0];
        CustomerModel * customer=[[CustomerModel alloc]init];
        NSString * newID=[dataDict objectForKey:@"newID"];
        customer.sysid=[NSString stringWithFormat:@"%d",rowid];
        customer._id=newID;
        [self updateCustomerLocalID:customer];
    }
}

-(BOOL)updateCustomerLocalID:(CustomerModel*)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSString * sql=[NSString stringWithFormat:@"UPDATE %@ SET _id='%@',contactid='%@' WHERE sysid= %@",@"ID_Customer",sender._id,model._id,sender.sysid];
        if ([db executeUpdate:sql]) {
            [db close];
            return true;
        }
    }
    [db close];
    return false;
}

-(void)deleteTap
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"确认删除该号码吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        [self deleteAction];
    }
}

-(void)deleteAction
{
    if (![self deleteContactInLocal]) {
        return;
    }
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    //NSString* userid = [Defaults objectForKey:@"userid"];
    NSDictionary * telDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self getResult:model._id], nil] forKeys:[NSArray arrayWithObjects:@"id", nil]];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/delete_personal_addressbook?id=%@&verify=%@&addressbook=%@",_ids,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (error==NULL) {
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        PersonalViewController * customer=[self.navigationController.viewControllers objectAtIndex:index-1];
        customer.status=@"0";
        [self.navigationController popToViewController:customer animated:YES];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger tag=textField.tag;
    UITableView * table=(UITableView*)textField.superview.superview.superview;
    UIScrollView * scroll=(UIScrollView *)[table superview];
    CGSize size= scroll.contentSize;
    size.height=900;
    scroll.contentSize=size;
    float height= [[UIScreen mainScreen]bounds].size.height;
    if (height==480) {
        if (tag>=3) {
            [scroll scrollRectToVisible:CGRectMake(0, 40*(tag-3), 320, table.frame.size.height) animated:YES];
        }
    }else
    {
        if (tag>3) {
            [scroll scrollRectToVisible:CGRectMake(0, 40*(tag-4), 320, table.frame.size.height) animated:YES];
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger tag= textField.tag;
    NSInteger row=1;
    NSInteger section=0;
    if (tag==1) {
        section=1;row=2;
    }else if(tag>1)
    {
        section=1;row=tag;
    }
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    CusInfoCell * cell=(CusInfoCell*)[_tableview cellForRowAtIndexPath:indexPath];
    if (tag==dictAll.count) {
        UITableView * table=(UITableView*)textField.superview.superview.superview;
        UIScrollView * scroll=(UIScrollView *)[table superview];
        CGSize size= scroll.contentSize;
        size.height=665;
        scroll.contentSize=size;
        [textField resignFirstResponder];
    }
    [cell._tetLabel becomeFirstResponder];
    return YES;
}

@end
