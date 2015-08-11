//
//  newUsercontact.m
//  Communication
//
//  Created by helloworld on 15/8/4.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "newUsercontact.h"
#import "Header.h"
#import "PersonMarkModel.h"
#import "MBProgressHUD.h"
#import "FMDatabase.h"
#import "JSONKit.h"
#import "PersonalViewController.h"
#import "PublicAction.h"
#import "MasterViewController.h"
@interface newUsercontact ()

@end

@implementation newUsercontact
@synthesize contact;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        label.text=@"添加个人";
        label.textColor=[UIColor whiteColor];
        label.tintColor=[UIColor whiteColor];
        self.navigationItem.titleView=label;
        
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
    self.view.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    [self drawview];
}

-(void)drawview
{
    UIView * nameView=[[UIView alloc]initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 40)];
    nameView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nameView];
    
    UILabel * nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
    nameLab.text=@"姓名";
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=[UIFont systemFontOfSize:14];
    [nameView addSubview:nameLab];
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 40)];
    nameField.font=[UIFont systemFontOfSize:14];
    nameField.text=contact.name;
    [nameView addSubview:nameField];
    
    UIView * mobileView=[[UIView alloc]initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, 40)];
    mobileView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mobileView];
    
    UILabel * mobileLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
    mobileLab.text=@"手机";
    mobileLab.textAlignment=NSTextAlignmentLeft;
    mobileLab.font=[UIFont systemFontOfSize:14];
    [mobileView addSubview:mobileLab];
    mobileField=[[UITextField alloc]initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 40)];
    mobileField.font=[UIFont systemFontOfSize:14];
    mobileField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    mobileField.text=contact.mobilePhone;
    [mobileView addSubview:mobileField];
    UIView * firsthr=[[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    firsthr.backgroundColor=COLOR(220,220,220,1);
    [mobileView addSubview:firsthr];
    
    UIView * phoneView=[[UIView alloc]initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, 40)];
    phoneView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:phoneView];
    
    UILabel * phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
    phoneLab.text=@"电话";
    phoneLab.textAlignment=NSTextAlignmentLeft;
    phoneLab.font=[UIFont systemFontOfSize:14];
    [phoneView addSubview:phoneLab];
    phoneField=[[UITextField alloc]initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 40)];
    phoneField.font=[UIFont systemFontOfSize:14];
    phoneField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    phoneField.text=contact.telephone1;
    [phoneView addSubview:phoneField];
    UIView * secondhr=[[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    secondhr.backgroundColor=COLOR(220,220,220,1);
    [phoneView addSubview:secondhr];
    
    firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 204, self.view.frame.size.width, 60)];
    firstView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:firstView];
    
    secondView=[[UIView alloc]initWithFrame:CGRectMake(0, 274, self.view.frame.size.width, self.view.frame.size.height-274)];
    secondView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:secondView];
    
    UILabel * firstlab=[[UILabel alloc]initWithFrame: CGRectMake(10, 5, 100, 20)];
    firstlab.text=@"已添加标签";
    firstlab.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:firstlab];
    
    UILabel * secondlab=[[UILabel alloc]initWithFrame: CGRectMake(10, 5, 100, 20)];
    secondlab.text=@"未添加标签";
    secondlab.font=[UIFont systemFontOfSize:14];
    [secondView addSubview:secondlab];
    //[self drawFirstButton];
    [self drawSecondButton];
}

-(void)drawFirstButton
{
    if (secondView!=nil) {
        for (UIView * v in firstView.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                UIButton * btn=(UIButton *)v;
                [btn removeFromSuperview];
                [btn addTarget:self action:@selector(firstButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    if (self.cid==nil||[self.cid isEqual:[NSNull null]]||[self.cid isEqualToString:@""]) {
        return;
    }
    NSArray * cids=[self.cid componentsSeparatedByString:@","];
    for (int i=0;i<cids.count;i++)
    {
        float width=10;
        if (i!=0)
        {
            UIView * v=[firstView viewWithTag:[[cids objectAtIndex:i-1] integerValue]];
            width=v.frame.origin.x+v.frame.size.width+10;
        }
        NSString *str=[cids objectAtIndex:i];
        PersonMarkModel * m=[dict objectForKey:str];
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(width,30,m.groupname.length*20,20)];
        [btn setTitle:m.groupname forState:UIControlStateNormal];
        [btn setTitleColor:COLOR(35.0, 152.0, 217.0, 1) forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.layer.borderColor = [COLOR(35.0, 152.0, 217.0, 1) CGColor];
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius=10;
        btn.tag=[str integerValue];
        [btn addTarget:self action:@selector(firstButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [firstView addSubview:btn];
    }
}

-(void)drawSecondButton
{
    if (secondView!=nil) {
        for (UIView * v in secondView.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                UIButton * btn=(UIButton *)v;
                [btn removeFromSuperview];
                [btn addTarget:self action:@selector(firstButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    if (nid==nil||[nid isEqual:[NSNull null]]||[nid isEqualToString:@""]) {
        return;
    }
    NSArray * cids=[nid componentsSeparatedByString:@","];
    for (int i=0;i<cids.count;i++)
    {
        NSString *str=[cids objectAtIndex:i];
        PersonMarkModel * m=[dict objectForKey:str];
        float width=10;
        if (i!=0)
        {
            UIView * v=[secondView viewWithTag:[[cids objectAtIndex:i-1] integerValue]];
            width=v.frame.origin.x+v.frame.size.width+10;
        }
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(width,30,m.groupname.length*20,20)];
        [btn setTitle:m.groupname forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius=10;
        btn.tag=[str integerValue];
        [btn addTarget:self action:@selector(secondButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [secondView addSubview:btn];
    }
}

-(void)firstButtonTap:(UIButton *)sender
{
    NSString * str=[NSString stringWithFormat:@"%ld",[sender tag]];
    NSRange range=[self.cid rangeOfString:str];
    if (range.location==NSNotFound) {
        return;
    }
    if (range.location+range.length==self.cid.length&&range.location>0) {
        range.length++;
        range.location--;
    }else if(range.location+range.length<self.cid.length)
    {
        range.length++;
    }
    self.cid=[self.cid stringByReplacingCharactersInRange:range withString:@""];
    if (nid.length==0)
    {
        nid=str;
    }
    else
    {
        nid=[nid stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    [self drawFirstButton];
    [self drawSecondButton];
}

-(void)secondButtonTap:(UIButton *)sender
{
    NSString * str=[NSString stringWithFormat:@"%ld",[sender tag]];
    NSRange range=[nid rangeOfString:str];
    if (range.location==NSNotFound) {
        return;
    }
    if (range.location+range.length==nid.length&&range.location>0)
    {
        range.location--;
        range.length++;
    }else if(range.location+range.length<nid.length)
    {
        range.length++;
    }
    nid=[nid stringByReplacingCharactersInRange:range withString:@""];
    if (self.cid.length==0)
    {
        self.cid=str;
    }
    else
    {
        self.cid=[self.cid stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    [self drawFirstButton];
    [self drawSecondButton];
};


-(void)leftButtonreturn:(UIBarButtonItem*)left{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonreturn:(UIBarButtonItem *)right
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    NSString * name=[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * telephone=[mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * phone=[phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (contact==nil) {
        contact=[[PersonInfoModel alloc]init];
    }
    contact.name=name;contact.mobilePhone=telephone;contact.telephone1=phone;contact.cid=self.cid;
    contact.uid=[[NSUserDefaults standardUserDefaults] objectForKey:@"nid"];
    if (![self checkInput]) {
        return;
    }else
    {
        int rowid=[self saveContactTolocal];
        contact.sysid=[NSString stringWithFormat:@"%d",rowid];
        if (rowid!=0) {
            [self insertContactWithUrl:rowid];
        }
    }
}

-(void)showMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    [hud hide:YES afterDelay:1];
    hud.labelText = @"添加用户成功!";
    [self.navigationController.view addSubview:hud];
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    if (_status==1)
    {
        MasterViewController * master=(MasterViewController *) [self.navigationController.viewControllers objectAtIndex:index-1];
        master.status=1;
        [self.navigationController popToViewController:master animated:YES];
    }else
    {
        PersonalViewController* customer=[self.navigationController.viewControllers objectAtIndex:index-1];
        customer.status=@"1";
        [self.navigationController popToViewController:customer animated:YES];
    }
}

-(void)insertContactWithUrl:(int)rowid
{
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSArray * arr1= [NSArray arrayWithObjects:[self getResult:contact.name],[self getResult:contact.mobilePhone],[self getResult:contact.telephone1],[NSString stringWithFormat:@"%d",rowid],[self getResult:contact.uid],[self getResult:contact.cid], nil];
    NSArray * arr2= [NSArray arrayWithObjects:@"name",@"mobilePhone",@"telephone1",@"sysId",@"uid",@"cid", nil];
    NSDictionary * telDict= [NSDictionary dictionaryWithObjects:arr1 forKeys:arr2];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/insert_personal_addressbook?id=%@&verify=%@&addressbook=%@",_ids,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error==NULL) {
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dic) {
            NSArray * array=[dic objectForKey:@"insert_result"];
            NSDictionary * dataDict= [array objectAtIndex:0];
            //group._id=[dataDict objectForKey:@"newID"];
            [self updateContactInlocal:[dataDict objectForKey:@"newID"]];
        }
    }
}

-(BOOL)updateContactInlocal:(NSString *)_id
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        if (contact==nil) {
            return false;
        }
        NSString * sql=[NSString stringWithFormat:@"update ID_Usercontact set _id='%@' where sysid='%@'",_id,contact.sysid];
        return [db executeUpdate:sql];
    }
    return  false;
}

-(NSString *)getResult:(NSString *)str
{
    if (str==nil||[str isEqual:[NSNull null]]) {
        return @"";
    }
    return str;
}

-(int)saveContactTolocal
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        if (contact==nil) {
            return 0;
        }
        NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (_id,address,fax,department, birthday, mobilePhone, telephone1, telephone2, cid, company, email, ctime , industry, internet, job, name, password, pid , remark , status,uid,sign) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"ID_Usercontact",[self getResult:contact._id],[self getResult:contact.address],[self getResult:contact.fax],[self getResult:contact.department],[self getResult:contact.birthday],[self getResult:contact.mobilePhone],[self getResult:contact.telephone1],[self getResult:contact.telephone2],[self getResult:contact.cid],[self getResult:contact.company],[self getResult:contact.email],[self getResult:contact.ctime],[self getResult:contact.industry],[self getResult:contact.internet],[self getResult:contact.job],[self getResult:contact.name],[self getResult:contact.password],[self getResult:contact.pid],[self getResult:contact.remark],[self getResult:contact.status],[self getResult:contact.uid],[self getResult:contact._id]];
        //把数据保存到数据库的@"ID_Enterprise"表里
        BOOL result=[db executeUpdate:inserSql];
        if (result) {
            NSString * sql=@"SELECT last_insert_rowid() from ID_Usercontact";
            FMResultSet * resultSet=[db executeQuery:sql];
            if ([resultSet next])
            {
                int rowid=[resultSet intForColumnIndex:0];
                [db close];
                if (_status==1) {
                    [PublicAction changeContactType:[NSDictionary dictionaryWithObjectsAndKeys:@"个人",contact._id, nil]];
                }
                [self showMessage];
                return rowid;
            }
        }
    }
    [db close];
    return 0;
}

-(BOOL)checkInput
{
    NSString * name=[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * telephone=[mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    UIWindow *win=[[UIApplication sharedApplication].windows objectAtIndex:1];
    if (name.length==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        hud.labelText = @"姓名不能为空";
        [nameField becomeFirstResponder];
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
        [mobileField becomeFirstResponder];
        return false;
    }
    return  true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData
{
    if (dict==nil) {
        dict=[NSMutableDictionary dictionary];
    }
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
        [self loadMarkLocalData];
    }else
    {
        [self.dataArray removeLastObject];
    }
    nid=[NSMutableString stringWithFormat:@"%@",@""];
    for (PersonMarkModel * group in self.dataArray)
    {
        if ([nid isEqualToString:@""])
        {
            nid=[nid stringByAppendingFormat:@"%@",group._id];
        }else
        {
            nid=[nid stringByAppendingFormat:@",%@",group._id];
        }
        [dict setValue:group forKey:group._id];
    }
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
    while ([result next]) {
        PersonMarkModel *model = [[PersonMarkModel alloc] init];
        model._id = [result stringForColumn:@"_id"];
        model.groupname = [result stringForColumn:@"groupname"];
        model.ctime = [result stringForColumn:@"ctime"];
        model.status=@"0";
        [_dataArray addObject:model];
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
