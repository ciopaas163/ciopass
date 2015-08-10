//
//  KeyViewController.m
//  Communication
//
//  Created by helloworld on 15/7/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//


#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
#import "KeyViewController.h"
#import "Header.h"
#import "PublicAction.h"
#import "IphoneController.h"
#import "XMLReader.h"
#import "JSONKit.h"
#import "SGInfoAlert.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
@interface KeyViewController ()

@end

@implementation KeyViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    {
        if (self) {
            self.tabBarController.delegate=self;
            
            lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 25)];
            lab.text=@"通信助手";
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=[UIColor whiteColor];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.textColor=[UIColor whiteColor];
            lab.font = [UIFont boldSystemFontOfSize:17];
            self.navigationItem.titleView=lab;
            
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    //self.navigationController.navigationBar.backgroundColor=[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    if (isShow) {
        [field becomeFirstResponder];
    }else{
        [field resignFirstResponder];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keywordboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keywordboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isShow=YES;
    isShowRightBtn=NO;
    field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    field.keyboardType=UIKeyboardTypeNumberPad;
    AFFNumericKeyboard *keyboard = [[AFFNumericKeyboard alloc]init];
    field.inputView = keyboard;
    keyboard.delegate=self;
    [self.view addSubview:field];
    self.tabBarController.delegate=self;
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.tableFooterView=[[UIView alloc]init];
    _tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableview];
    [PublicAction tableViewCenter:_tableview];
    
}

-(void)numberKeyboardInput:(NSInteger)number
{
    isShowRightBtn=YES;
    if (number==10)
    {
        field.text = [field.text stringByAppendingString:@"*"];
    }else if(number==12)
    {
        field.text = [field.text stringByAppendingString:@"#"];
    }else
    {
        field.text = [field.text stringByAppendingString:[NSString stringWithFormat:@"%ld",number]];
    }
    if (isShowRightBtn)
    {
        UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dial_delete_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clearText)];
        rightBtn.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem=rightBtn;
        lab.text=field.text;
    }

    [self loadContact:field.text];
    [_tableview reloadData];
}

-(void)clearText
{
    self.navigationItem.rightBarButtonItem=nil;
    lab.text=@"通讯助手";
    field.text=@"";
}

-(void)loadContact:(NSString *)telephoneNum
{
    
}

- (void)keywordboardHide:(NSNotification*)aNotification{
    [field resignFirstResponder];
    [view removeFromSuperview];
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    tempWindow.frame=CGRectMake(0, 0, KSCREENWIDTH, KSCRENHEIGHT);
}

- (void)keywordboardShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    tempWindow.frame=CGRectMake(0, -103, KSCREENWIDTH, KSCRENHEIGHT);
    
   /* if (doneInKeyboardButton == nil){
        //初始化完成按钮
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
        doneInKeyboardButton.frame=CGRectMake(0, 216, 104, 53);
        [doneInKeyboardButton setTitle:@"*" forState:UIControlStateNormal];
        doneInKeyboardButton.backgroundColor=[UIColor whiteColor];
        doneInKeyboardButton.titleLabel.font=[UIFont boldSystemFontOfSize:25];
        doneInKeyboardButton.tintColor=[UIColor blackColor];
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (doneInKeyboardButton.superview == nil){
        //完成按钮添加到window
        [tempWindow addSubview:doneInKeyboardButton];
    }
    if (rightInKeyboardButton==nil) {
        rightInKeyboardButton=[UIButton buttonWithType:UIButtonTypeSystem];
        rightInKeyboardButton.frame=CGRectMake(216, 216, 104, 53);
        [rightInKeyboardButton setTitle:@"#" forState:UIControlStateNormal];
        rightInKeyboardButton.backgroundColor=[UIColor whiteColor];
        //[signBtn.layer setBorderWidth:1.0]
        rightInKeyboardButton.titleLabel.font=[UIFont boldSystemFontOfSize:25];
        rightInKeyboardButton.tintColor=[UIColor blackColor];
        [rightInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [tempWindow addSubview:rightInKeyboardButton];*/
    
    view=[[UIView alloc]initWithFrame:CGRectMake(-1, KSCRENHEIGHT-103, KSCREENWIDTH+2, 55)];
    view.layer.borderWidth=1;
    view.layer.borderColor=[COLOR(211,211,211,1) CGColor];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    if (newToInKeyboarButton==nil) {
        newToInKeyboarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 95, 52)];
        newToInKeyboarButton.backgroundColor=[UIColor whiteColor];
        newToInKeyboarButton.titleLabel.font=[UIFont boldSystemFontOfSize:25];
        newToInKeyboarButton.tintColor=[UIColor blackColor];
        [newToInKeyboarButton setImage:[UIImage imageNamed:@"添加联系人.png"] forState:UIControlStateNormal];
        [newToInKeyboarButton addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];

    }
    [view addSubview:newToInKeyboarButton];
    if (deletInKeyboarButton==nil) {
        deletInKeyboarButton=[[UIButton alloc]initWithFrame:CGRectMake(225, 0, 95, 52)];
        deletInKeyboarButton.backgroundColor=[UIColor whiteColor];
        deletInKeyboarButton.titleLabel.font=[UIFont boldSystemFontOfSize:25];
        deletInKeyboarButton.tintColor=[UIColor blackColor];
        [deletInKeyboarButton setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
        [deletInKeyboarButton addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [view addSubview:deletInKeyboarButton];
    if (DialInKeyboarButton==nil) {
        DialInKeyboarButton=[[UIButton alloc]initWithFrame:CGRectMake(95, 4, 130, 44)];
        DialInKeyboarButton.backgroundColor=[UIColor whiteColor];
        DialInKeyboarButton.layer.cornerRadius=44/2;
        DialInKeyboarButton.titleLabel.font=[UIFont boldSystemFontOfSize:25];
        DialInKeyboarButton.backgroundColor=[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1];
        //DialInKeyboarButton.tintColor
        [DialInKeyboarButton setImage:[UIImage imageNamed:@"dial_tel_icon.png"] forState:UIControlStateNormal];
        [DialInKeyboarButton addTarget:self action:@selector(dialTelephone) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [view addSubview:DialInKeyboarButton];

}


-(void)dialTelephone
{
    if (field.text.length<7) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    IphoneController * dial=[[IphoneController alloc]init];
    dial.number=field.text;
    dial.address=[PublicAction getTelephoneLocation:field.text];
    [self presentViewController:dial animated:YES completion:nil];
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* _userid = [Defaults objectForKey:@"userid"];
    NSString * _number=[Defaults objectForKey:@"Num"];
    NSDictionary * dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_ids,_eid,_verify,_userid,_number,field.text, nil] forKeys:[NSArray arrayWithObjects:@"_id",@"eid",@"verify",@"userid",@"number",@"callNum", nil]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [PublicAction dialTelephone:dict];
    });
}

-(void)addContact
{
    ABNewPersonViewController * new=[[ABNewPersonViewController alloc]init];
    [self presentViewController:new animated:YES completion:nil];
}

-(void)deleteText
{
    NSMutableString * str= [NSMutableString stringWithString:field.text];
    if (str.length>0)
    {
        NSRange range={str.length-1,1};
        [str deleteCharactersInRange:range];
        field.text=str;
        lab.text=str;
        if (str.length==0)
        {
            lab.text=@"通讯助手";
            field.text=@"";
        }
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    if (isShow) {
        tempWindow.alpha=0;
        tempWindow.hidden=YES;
        UITabBarItem * items= [self.tabBarController.tabBar.items objectAtIndex:1];
        items.selectedImage=[UIImage imageNamed:@"keyboard-close.png"];
        [field resignFirstResponder];
        isShow=NO;
    }else{
        tempWindow.alpha=1;
        tempWindow.hidden=NO;
        UITabBarItem * items= [self.tabBarController.tabBar.items objectAtIndex:1];
        items.selectedImage=[UIImage imageNamed:@"keyboard-blue.png"];
        [field becomeFirstResponder];
        isShow=YES;
    }
    if (self.tabBarController.selectedIndex!=1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Cell = @"cell";
    UITableViewCell * tableCell =[tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell==nil) {
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    tableCell.imageView.image=[UIImage imageNamed:@""];
    tableCell.textLabel.text=@"hello";
    
    return tableCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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
