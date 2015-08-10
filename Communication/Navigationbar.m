//
//  Navigationbar.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Navigationbar.h"

@interface Navigationbar ()

@end

@implementation Navigationbar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    //创建一个导航栏
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //创建一个导航栏集合
    _navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //创建一个左边按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftButton:)];
    //设置图片
    //    UIBarButtonItem * leftButton = [UIBarButtonItem alloc]initWithImage:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(clickLeftButton:)];
    
//    //设置导航栏的内容
//    _navItem.title = @"个人注册";
    //把导航栏集合添加到导航栏中，设置动画关闭
    [_navBar pushNavigationItem:_navItem animated:YES];
    //把左右两个按钮添加到导航栏集合中去
    [_navItem setLeftBarButtonItem:leftButton];
    //将标题栏中的内容全部添加到主视图当中
    [self.view addSubview:_navBar];
    _textLabel =  [[UILabel alloc] initWithFrame:CGRectMake(30, _navBar.frame.origin.y + _navBar.frame.size.height + 50 , 70, 30)];
    _textLabel.text = @"手机号";
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_textLabel];

    
    _iphoneText = [[UITextField alloc] initWithFrame:CGRectMake(_textLabel.frame.origin.x + _textLabel.frame.size.width + 10, _navBar.frame.origin.y + _navBar.frame.size.height + 50, self.view.frame.size.width  - (_textLabel.frame.size.width ) *2 , _textLabel.frame.size.height)];
    _iphoneText.backgroundColor = [UIColor whiteColor];
//    _inputText.layer.borderColor = [[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1]CGColor];
//    _inputText.layer.borderWidth = 1;
    _iphoneText.delegate = self;
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _iphoneText.leftViewMode = UITextFieldViewModeAlways;
    _iphoneText.leftView = leftView;
    [self.view addSubview:_iphoneText];
    
    //验证码
    _numberText = [[UITextField alloc] initWithFrame:CGRectMake(_iphoneText.frame.origin.x, _iphoneText.frame.origin.y + _iphoneText.frame.size.height + 30, _iphoneText.frame.size.width / 2 + 10, _iphoneText.frame.size.height)];
    _numberText.backgroundColor = [UIColor whiteColor];
    _numberText.delegate = self;
    UIView* leftViewNumber = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _numberText.leftViewMode = UITextFieldViewModeAlways;
    _numberText.leftView = leftViewNumber;
    [self.view addSubview:_numberText];
    
    UIButton* btnNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNumber.frame = CGRectMake(_numberText.frame.origin.x + _numberText.frame.size.width + 5, _numberText.frame.origin.y, _iphoneText.frame.size.width - _numberText.bounds.size.width - 5, _numberText.frame.size.height);
    btnNumber.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:125.0/255.0 blue:33.0/255.0 alpha:1];
    [btnNumber setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnNumber.titleLabel.font = [UIFont systemFontOfSize:13];
    btnNumber.layer.cornerRadius = 4;
    [btnNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNumber.tag = 31;
    [btnNumber addTarget:self action:@selector(buttonMonitor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNumber];

    for (int j = 0 ; j <2; j++) {

        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(_numberText.frame.origin.x, _numberText.frame.origin.y + _numberText.frame.size.height + 30 + j *(30+ 30), _iphoneText.frame.size.width, _numberText.frame.size.height)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.delegate = self;
        UIView* leftViewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftViewPassword;
        [self.view addSubview:_password];
        
    }

        
    
}
#pragma mark 按钮
-(void)clickLeftButton:(UIBarButtonItem*)leftbutton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark button
-(void)buttonMonitor:(UIButton*)monitor{
    if (monitor.tag == 31) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:nil
                                                       delegate:self cancelButtonTitle:nil
                                              otherButtonTitles: nil];
        //2秒钟后自动移除
        [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
        [alert show];

    }
}
#pragma mark 改变 【textField选择框边的颜色】
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    textField.layer.borderColor = [[UIColor colorWithRed:233.0/255.0 green:125.0/255.0 blue:33.0/255.0 alpha:1]CGColor];
    textField.layer.borderWidth = 1.5;
    
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.layer.borderColor = [[UIColor whiteColor]CGColor];
    textField.layer.borderWidth = 0.5;
    return YES;
}


- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
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
