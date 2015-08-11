//
//  KeyViewController.h
//  Communication
//
//  Created by helloworld on 15/7/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AFFNumericKeyboard.h"
@interface KeyViewController : UIViewController<UITabBarControllerDelegate,AFFNumericKeyboardDelegate,UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
{
    UITextField * field;
    UIButton * newToInKeyboarButton;
    UIButton * deletInKeyboarButton;
    UIButton * DialInKeyboarButton;
    UIView * view;
    UITableView * _tableview;
    BOOL isShow;
    BOOL isShowRightBtn;
    UILabel * lab;
    NSMutableString * location;
}
@end
