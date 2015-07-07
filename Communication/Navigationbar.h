//
//  Navigationbar.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Navigationbar : UIViewController

<UITextFieldDelegate>

{
    UINavigationBar* _navBar;
    UINavigationItem* _navItem;
    
        UILabel* _textLabel;
        
        UITextField* _inputText;
        
        
        UITextField* _iphoneText;       //手机号
        UITextField* _numberText;       //验证码
        UITextField* _psswordText;      //密码输入框
        UITextField* _password;         //确认密码输入框
        
        
        
}
@end
