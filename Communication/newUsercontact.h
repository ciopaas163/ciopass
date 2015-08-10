//
//  newUsercontact.h
//  Communication
//
//  Created by helloworld on 15/8/4.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoModel.h"
@interface newUsercontact : UIViewController
{
    UIView * firstView;
    UIView * secondView;
    UITextField * nameField;
    UITextField * mobileField;
    UITextField * phoneField;
    
    NSString * nid;
    NSMutableDictionary * dict;
}
@property (strong,nonatomic)PersonInfoModel * contact;
@property (strong,nonatomic)NSMutableArray * dataArray;
@property (strong,nonatomic)NSString * cid;
@property (assign,nonatomic)NSInteger status;
@end
