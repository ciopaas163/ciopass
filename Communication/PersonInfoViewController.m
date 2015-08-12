//
//  PersonInfoViewController.m
//  Communication
//
//  Created by helloworld on 15/7/20.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PublicAction.h"
#import "PersonInfoCell.h"
#import "IphoneController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PublicAction.h"
@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController
@synthesize model;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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

-(void)back
{
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1]animated:YES];
    [_tableview reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (dataArray==nil) {
        dataArray=[NSMutableArray arrayWithCapacity:2];
    }else
    {
        [dataArray removeAllObjects];
    }
    
    NSDictionary * dict1=[NSDictionary dictionaryWithObject:model.username forKey:@"a姓名"];
    NSMutableDictionary * dict2=[[NSMutableDictionary alloc]initWithCapacity:6];
    [dict2 setValue:model.position forKey:@"a职位"];
    [dict2 setValue:model.mobilePhone forKey:@"b手机"];
    [dict2 setValue:model.telephone1 forKey:@"c电话1"];
    [dict2 setValue:model.telephone2 forKey:@"d电话2"];
    [dict2 setValue:model.email forKey:@"e邮箱"];
    [dict2 setValue:@"" forKey:@"f地址"];
    [dataArray addObject:dict1];
    [dataArray addObject:dict2];
    [_tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableview];
    [PublicAction tableViewCenter:_tableview];
    [_tableview setTableFooterView:[UIView new]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[dataArray objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"cell";
    PersonInfoCell* tableCell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell == nil) {
        tableCell = [[PersonInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell];
    }
    NSDictionary * dict=[dataArray objectAtIndex:indexPath.section];
    NSString * key=[[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.row];
    NSString * value=[dict objectForKey:key];
    tableCell.title=[key substringFromIndex:1];
    tableCell.subtitle=value;
    if (indexPath.section==1)
    {
        if (indexPath.row==1||indexPath.row==2||indexPath.row==3)
        {
            if (value.length>0)
            {
                UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 5, 30, 30)];
                [btn setImage:[UIImage imageNamed:@"dial_normal.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"dial_down.png"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(photoTapped) forControlEvents:UIControlEventTouchUpInside];
                [tableCell.contentView addSubview:btn];
            }
        }
    }
    return tableCell;
}

-(void)photoTapped
{
    if (model.mobilePhone.length<7) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    IphoneController * dial=[[IphoneController alloc]init];
    dial.number=model.mobilePhone;
    dial.address=[PublicAction getTelephoneLocation:model.mobilePhone];
    [self presentViewController:dial animated:YES completion:nil];
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* _userid = [Defaults objectForKey:@"userid"];
    NSString * _number=[Defaults objectForKey:@"Num"];
    NSDictionary * dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_ids,_eid,_verify,_userid,_number,model.mobilePhone, nil] forKeys:[NSArray arrayWithObjects:@"_id",@"eid",@"verify",@"userid",@"number",@"callNum", nil]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [PublicAction dialTelephone:dict];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:NO];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
