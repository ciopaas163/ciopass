//
//  UsercontactGroup.m
//  Communication
//
//  Created by helloworld on 15/8/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "UsercontactGroup.h"
#import "FMDatabase.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "PersonInfoModel.h"
#import "JSONKit.h"
#import "PublicAction.h"
@interface UsercontactGroup ()

@end

@implementation UsercontactGroup

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        label.text=@"标签";
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
    return  self;
}

-(void)leftButtonreturn:(UIBarButtonItem*)left{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonreturn:(UIBarButtonItem *)right
{
    if (_customerArray)
    {
        NSArray * array=[self saveContactToLocal];
        if (array.count>0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            [hud hide:YES afterDelay:1];
            hud.labelText = @"添加用户成功!";
            [self.navigationController.view addSubview:hud];
            
            NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary * dic= [self saveContactWithUrl:array];
                [self updateContactLocalID:dic];
            });
        }
    }
}

-(NSArray *)saveContactToLocal
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    NSMutableArray * array=[[NSMutableArray alloc]init];
    NSMutableDictionary * data=[[NSMutableDictionary alloc]init];
    if ([db open])
    {
        for (int i=0; i<_customerArray.count; i++)
        {
            PersonInfoModel * model=[_customerArray objectAtIndex:i];
            NSString* inserSql = [NSString stringWithFormat:@"INSERT INTO %@ (name,mobilePhone, telephone1,cid,sign) VALUES ('%@','%@','%@','%@','%@')",@"ID_Usercontact",[self getResult:model.name],[self getResult:model.mobilePhone],[self getResult:model.telephone1],[self getResult:_cid],[self getResult:model._id]];
            BOOL result= [db executeUpdate:inserSql];
            if (result) {
                NSString * sql=@"SELECT last_insert_rowid() from ID_Usercontact";
                FMResultSet * resultSet=[db executeQuery:sql];
                if ([resultSet next])
                {
                    NSString * rowid=[resultSet stringForColumnIndex:0];
                    [array addObject:rowid];
                    [data setValue:@"个人" forKey:model._id];
                }
            }
        }
    }
    [db close];
    [PublicAction changeContactType:data];
    return [array sortedArrayUsingSelector:@selector(compare:)];
}

-(NSString *)getResult:(NSString *)str
{
    if (str==nil||[str isEqual:[NSNull null]]) {
        return @"";
    }
    return str;
}

-(NSDictionary *)saveContactWithUrl:(NSArray*)arr
{
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* userid = [Defaults objectForKey:@"userid"];
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (int i=0; i<_customerArray.count; i++)
    {
        PersonInfoModel * cus=[_customerArray objectAtIndex:i];
        NSDictionary * telDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:userid,[self getResult:cus.name],[self getResult:cus.mobilePhone],[self getResult:cus.telephone1],[self getResult:_cid],arr[i],_eid, nil] forKeys:[NSArray arrayWithObjects:@"userId",@"name",@"mobilePhone",@"telephone1",@"cid",@"sysId",@"uid", nil]];
        [array addObject:telDict];
    }
    NSLog(@"%@",arr);
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:array forKey:@"DataList"];
    
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/insert_personal_addressbook?id=%@&verify=%@&addressbook=%@",_ids,_verify,[datalist JSONString]];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
    NSData * data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    return dic;
}

-(void)updateContactLocalID:(NSDictionary*)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"commun.db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    if ([db open])
    {
        NSArray * array=[sender objectForKey:@"insert_result"];
        for (int i=0; i<array.count; i++) {
            NSDictionary * dataDict= [array objectAtIndex:i];
            NSString * _id=[dataDict objectForKey:@"newID"];
            NSString * sysid=[dataDict objectForKey:@"sysId"];
            NSString * sql=[NSString stringWithFormat:@"UPDATE %@ SET _id='%@' WHERE sysid= %@",@"ID_Usercontact",_id,sysid];
            [db executeUpdate:sql];
        }
    }
    [db close];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    [self drawview];
}

-(void)drawview
{
    firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 60)];
    firstView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:firstView];
    
    secondView=[[UIView alloc]initWithFrame:CGRectMake(0, 144, self.view.frame.size.width, self.view.frame.size.height-144)];
    secondView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:secondView];
    
    UILabel * firstlab=[[UILabel alloc]initWithFrame: CGRectMake(10, 5, 100, 20)];
    firstlab.text=@"已添加标签";
    firstlab.font=[UIFont systemFontOfSize:12];
    [firstView addSubview:firstlab];
    
    UILabel * secondlab=[[UILabel alloc]initWithFrame: CGRectMake(10, 5, 100, 20)];
    secondlab.text=@"未添加标签";
    secondlab.font=[UIFont systemFontOfSize:12];
    [secondView addSubview:secondlab];
    [self drawFirstButton];
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
        NSString *str=[cids objectAtIndex:i];
        float width=10;
        if (i!=0)
        {
            UIView * v=[firstView viewWithTag:[[cids objectAtIndex:i-1] integerValue]];
            width=v.frame.origin.x+v.frame.size.width+10;
        }
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(width,30,[[dict objectForKey:str] length]*20,20)];
        [btn setTitle:[dict objectForKey:str] forState:UIControlStateNormal];
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
        float width=10;
        if (i!=0)
        {
            UIView * v=[secondView viewWithTag:[[cids objectAtIndex:i-1] integerValue]];
            width=v.frame.origin.x+v.frame.size.width+10;
        }
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(width,30,[[dict objectForKey:str] length]*20,20)];
        [btn setTitle:[dict objectForKey:str] forState:UIControlStateNormal];
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


-(void)loadData
{
    if (self.cid==nil||[self.cid isEqual:[NSNull null]]) {
        self.cid=@"";
    }
    for (NSString * str in dict.allKeys)
    {
        NSRange range=[self.cid rangeOfString:str];
        if (range.location==NSNotFound)
        {
            if (nid.length==0)
            {
                nid=str;
            }
            else
            {
                nid=[nid stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGroups];
    nid=@"";[self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadGroups
{
    dict=[[NSMutableDictionary alloc]init];
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
        [dict setObject:[result stringForColumn:@"groupname"] forKey:[result stringForColumn:@"_id"]];
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
