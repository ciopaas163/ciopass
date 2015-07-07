//
//  DialViewController.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@protocol PDCCallViewDelegate;

@interface DialViewController : PublicViewController

<UITextFieldDelegate,UIActionSheetDelegate,ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate,UIAlertViewDelegate>

{
    float size_x;
    float size_y;

    NSString *numStr;//phone number

    UIButton* _btnDelete;

    UIButton* _btnAdd;

    UIButton* _btnNumber;

    UILabel* _abcLabel;

    UITextField *textV;

    NSTimer *timer;

    UIView* _mobileVie; // 用来移动的view；

    NSMutableString * _str;


    UIActionSheet*  _callActionsheet;

    UIActionSheet *_actionSheet;

    NSMutableDictionary *sectionDic;
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
    NSMutableArray *filteredArray;
    
   
}

@property (nonatomic, weak) id<PDCCallViewDelegate> delegate;

@end

@protocol PDCCallViewDelegate <NSObject>

@optional

- (void)PDCCallViewDelegate_hidden;//hid delegate

@end