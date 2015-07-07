//
//  ViewController.m
//  Communication
//
//  Created by CIO on 15/2/27.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "ViewController.h"
#import "RegistrationController.h" //注册
#import "CipherViewController.h"   //忘记密码
#import "AppDelegate.h"
#import "TabBarController.h"
#import "SGInfoAlert.h"
#import "MBProgressHUD.h"
#import "TabBarGeRenViewController.h"

#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()<NSURLConnectionDataDelegate>
{
    NSDictionary *resultDic2;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableData *data_;
    NSUserDefaults *userDefaults;
    UITextField *numTextFiled;
    UITextField *passwordTextFiled;
    CGRect oldFrame_;
}
@property (nonatomic,strong) UIScrollView *contentScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    data_ = [[NSMutableData alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    
    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH,KSCRENHEIGHT)];
    [self.view addSubview:self.contentScrollView];
    UIImageView* imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width /2 - 80/2, self.view.frame.size.height/6, 80, 80)];
    imgLogo.image = [UIImage imageNamed:@"LOGO.png"];
    [self.contentScrollView addSubview:imgLogo];
    
    //长方形的线框
    UILabel* frameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,imgLogo.frame.origin.y + imgLogo.bounds.size.height + imgLogo.bounds.size.height/2, self.view.frame.size.width - 30*2, imgLogo.bounds.size.height / 2 + 40)];
    frameLabel.layer.borderWidth = 0.5;
    frameLabel.layer.cornerRadius = 5;
    frameLabel.userInteractionEnabled = YES;
    frameLabel.layer.borderColor = [[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1]CGColor];
    [self.contentScrollView addSubview:frameLabel];
    
    //横线
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(frameLabel.bounds.origin.x + 5, frameLabel.bounds.origin.y+frameLabel.bounds.size.height / 2, frameLabel.bounds.size.width - 5 * 2, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1];
    [frameLabel addSubview:line];
    
    //输入框
    NSArray* fieldArray = @[@" 请输入手机号",@" 请填写密码"];
    for (int s = 0; s < 2; s++) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(line.bounds.origin.x , line.bounds.origin.y + s* (frameLabel.bounds.size.height/2 + line.bounds.size.height), frameLabel.bounds.size.width, frameLabel.bounds.size.height/2)];
        _textField.backgroundColor = [UIColor whiteColor];
        //        textField.text = fieldArray[s];
        _textField.placeholder = fieldArray[s];
        _textField.delegate = self;
        _textField.tag = 20+s;
        _textField.layer.cornerRadius = 5;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
        if (_textField.tag == 21) {
            _textField.secureTextEntry = YES;
        }
        [frameLabel addSubview:_textField];
        
    }
    //登录按键
    UIButton* login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(frameLabel.frame.origin.x , frameLabel.bounds.size.height + frameLabel.frame.origin.y + imgLogo.bounds.size.height/2 , frameLabel.bounds.size.width, frameLabel.bounds.size.height /2);
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:145.0/255.0 blue:213.0/255.0 alpha:1];
    login.tag = 10;
    login.layer.cornerRadius = 5;
    [login addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:login];
    
    NSArray* textArray = @[@"个人注册",@"忘记密码"];
    for (int i = 0; i < 2; i++)
    {
        UIButton* btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTwo.frame = CGRectMake(login.frame.origin.x + login.frame.size.width / 8+ i * (35 + 80), login.frame.origin.y + login.frame.size.height*2 + 40, 80, 40);
        [btnTwo setTitle:textArray[i] forState:UIControlStateNormal];
        btnTwo.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btnTwo.tag = 11 +i;
        btnTwo.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnTwo addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:btnTwo];
    }
    
    numTextFiled =(UITextField *)[self.view viewWithTag:20];
    passwordTextFiled =(UITextField *)[self.view viewWithTag:21];
    userDefaults = [NSUserDefaults standardUserDefaults];
    numTextFiled.text = [userDefaults stringForKey:@"Num"];
    passwordTextFiled.text = [userDefaults stringForKey:@"Password"];
    
    [self addKeyboardObserver];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.contentScrollView addGestureRecognizer:tapGestureRecognizer];
    
}
-(void)boardHide:(UITapGestureRecognizer*)tap
{
    [numTextFiled resignFirstResponder];
    [passwordTextFiled resignFirstResponder];
}

-(void)addKeyboardObserver
{
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark  button 监听事件
-(void)buttonEvent:(UIButton*)event{
    [numTextFiled resignFirstResponder];
    [passwordTextFiled resignFirstResponder];
    switch (event.tag) {
        case 10:{
            NSLog(@"登录监听OK");
            [self userequest];
            break;
        }
        case 11:{
            NSLog(@"注册账号监听OK");
            RegistrationController* regContorller = [[RegistrationController alloc] init];
            //            self.navigationController.navigationBarHidden = NO;
            UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:regContorller];
            [self presentViewController:nvc animated:YES completion:nil];
            break;
        }
        case 12:{
            NSLog(@"忘记密码监听OK");
            CipherViewController* cipher = [[CipherViewController alloc]init];
            UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:cipher];
            [self presentViewController:nvc animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

-(void)userequest
{
    UITextField *nameTextFile =(UITextField *)[self.view viewWithTag:20];
    UITextField *passwordTextFile =(UITextField *)[self.view viewWithTag:21];
    
    // 显示加载指示器
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.contentScrollView animated:YES];
    hub.labelText = @"登入中...";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/get_cti_data?mobile=%@&passwd=%@&from=1",nameTextFile.text,passwordTextFile.text]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data_.length = 0;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:data_ options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"array-%@",array);
    NSString *resultw =[NSString stringWithFormat:@"%@",[array objectForKey:@"code"]];
    NSString *resulterr = @"1";
    NSString *GerenStr =[NSString stringWithFormat:@"%@",[array objectForKey:@"usertype"]];
    NSString *GeStr = @"3";
    
    NSString *userid;
    NSString *nid;
    NSString *eid;
    NSString *verify;
    
    for (NSInteger i=0; i<[array count]; i++) {
        userid = array[@"userid"];
        nid = array[@"id"];
        eid = array[@"eid"];
        verify = array[@"verify"];
    }
    [userDefaults setObject:userid forKey:@"userid"];
    [userDefaults setObject:nid forKey:@"nid"];
    [userDefaults setObject:eid forKey:@"eid"];
    [userDefaults setObject:verify forKey:@"verify"];
    
    [MBProgressHUD hideAllHUDsForView:self.contentScrollView animated:YES];
    if([resultw isEqualToString:resulterr])
    {
        
        [SGInfoAlert showInfo:@"请输入正确的用户名或密码"
         
                      bgColor: [UIColor orangeColor].CGColor
         
                       inView:self.view
         
                     vertical:0.8];
    }
    else
    {
        [userDefaults setObject:numTextFiled.text forKey:@"Num"];
        [userDefaults setObject:passwordTextFiled.text forKey:@"Password"];
        
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([GerenStr isEqualToString:GeStr])
        {
            app.window.rootViewController = [[TabBarGeRenViewController alloc]init];
        }
        else
        {
            app.window.rootViewController = [[TabBarController alloc]init];
        }
    }
    
}

#pragma mark     UITextField 方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark keyboard 键盘的出现和消失处理
- (void)keyboardHide:(NSNotification *)message
{
    NSDictionary *dict = message.userInfo;
    
    //获取键盘的动画参数
    NSNumber *duration = [dict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dict objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.contentScrollView.frame = self.view.bounds;
    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)message
{
    NSDictionary *dict = message.userInfo;
    
    id rectObject = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyBoardframe;
    //获取键盘的布局大小
    [rectObject getValue:&keyBoardframe];
    
    CGRect keyboardTypeViewFrame = oldFrame_;
    keyboardTypeViewFrame.origin.y -= keyBoardframe.size.height;
    
    
    //获取键盘的动画参数
    NSNumber *duration = [dict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dict objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.contentScrollView.frame = CGRectMake(0, -70, KSCREENWIDTH, KSCRENHEIGHT);
    // commit animations
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
