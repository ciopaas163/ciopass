//
//  AlterpasswordViewController.m
//  Communication
//
//  Created by helloworld on 15/2/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "AlterpasswordViewController.h"
#import "SGInfoAlert.h"
#import "AFNetworking.h"
#import "ViewController.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height

@interface AlterpasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *Strurl;
    NSString *oldpassword;
    NSString *newpassword;
    NSString *againpassword;
    UITextField* textField;
    
}
@end

@implementation AlterpasswordViewController


-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    //    [self usenavigationbarView];
    self.title = @"修改密码";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick:)];
    leftButton.tag = 40;
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick:)];
    leftButton.tag = 41;
    [self.navigationItem setRightBarButtonItem:rightButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self useTextFiled];
    
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
    [titleButton setText:@"修改密码"];
    [navigationbarView addSubview:titleButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:backButton];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREENWIDTH/6*5,8, 40, 26)];
    [addButton setTitle:@"保存"  forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:addButton];
    
}

-(void)useTextFiled
{
    
    for (NSInteger i=1; i<4; i++) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10,44+30*i+i*10,KSCREENWIDTH-20, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:15];
        
        textField.tag = i;
        textField.delegate =self;
        textField.secureTextEntry = YES;
        [self.view addSubview:textField];
    }
}

#pragma mark 返回
-(void)leftButtonClick:(UIBarButtonItem *)backItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存
-(void)rightButtonClick:(UIBarButtonItem *)saveItem
{
    UITextField *oldtext =(UITextField *)[self.view viewWithTag:1];
    UITextField *newtext =(UITextField *)[self.view viewWithTag:2];
    UITextField *againtext =(UITextField *)[self.view viewWithTag:3];
    
    NSString *oldpass =[NSString stringWithFormat:@"%@",oldtext.text];
    NSString *newpass =[NSString stringWithFormat:@"%@",newtext.text];
    
    if(newtext.text.length<6)
    {
        [SGInfoAlert showInfo:@"请输入6至16位新密码"
         
                      bgColor: [UIColor orangeColor].CGColor
         
                       inView:self.view
         
                     vertical:0.8];
        return;
    }
    if (![newtext.text isEqualToString:againtext.text])
    {
        [SGInfoAlert showInfo:@"再次输入新密码不一致"
         
                      bgColor: [UIColor orangeColor].CGColor
         
                       inView:self.view
         
                     vertical:0.8];
        return;
    }
    if ([oldpass isEqualToString:newpass])
    {
        [SGInfoAlert showInfo:@"新密码不能和旧密码一致！"
         
                      bgColor: [UIColor orangeColor].CGColor
         
                       inView:self.view
         
                     vertical:0.8];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *nid = [userDefaults stringForKey:@"nid"];
    
    NSString *verify = [userDefaults stringForKey:@"verify"];
    
    
    NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"newPass\":\"%@\",\"oldPass\":\"%@\"}]}",newpass,oldpass];
    NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    Strurl = [NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/update_password_data?id=%@&verify=%@&passworddata=%@",nid,verify,data];
    [self get4];
    
}

//网络请求数据方法
-(void)get4
{
    
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:Strurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //json解析数据
         
         NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         
         NSInteger result=[[Dic objectForKey:@"result"]integerValue];
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码修改成功，请重新登入！" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
         
         switch (result) {
             case 1:
                 [alertView show];
                 break;
             case 2:
                 [SGInfoAlert showInfo:@"密码修改失败"
                  
                               bgColor: [UIColor orangeColor].CGColor
                  
                                inView:self.view
                  
                              vertical:0.8];
                 
                 break;
             case 3:
                 [SGInfoAlert showInfo:@"密码修改失败"
                  
                               bgColor: [UIColor orangeColor].CGColor
                  
                                inView:self.view
                  
                              vertical:0.8];
                 break;
             case 4:
                 [SGInfoAlert showInfo:@"密码错误！"
                  
                               bgColor: [UIColor orangeColor].CGColor
                  
                                inView:self.view
                  
                              vertical:0.8];
                 break;
                 
             default:
                 break;
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SGInfoAlert showInfo:@"请求失败！"
          
                       bgColor: [UIColor orangeColor].CGColor
          
                        inView:self.view
          
                      vertical:0.8];
         
     }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ViewController* vcr = [[ViewController alloc]init];
    [self presentViewController:vcr animated:YES completion:nil];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
