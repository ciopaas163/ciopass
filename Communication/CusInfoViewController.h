//
//  CusInfoViewController.h
//  Communication
//
//  Created by helloworld on 15/7/21.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"
@interface CusInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITableView * _tableview;
    NSMutableArray * dataArray;
    NSMutableDictionary * markDict;
    BOOL showStatus;
    UIImageView * imageClose;
    NSMutableDictionary * dictOther;
    NSMutableDictionary * dictAll;
    NSMutableArray  * optionsArray;
    NSDictionary * dictHeard;
    UIButton * deleteCus;
    UIButton * recordBtn;
    NSArray * keys;
    CGPoint point;
    BOOL isChange;
}
@property (strong,nonatomic) CustomerModel * model;
@property (strong,nonatomic)NSArray* _mutableArray;
@property (assign,nonatomic)NSInteger optionStatus;
@end
