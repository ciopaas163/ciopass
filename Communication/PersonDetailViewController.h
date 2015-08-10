//
//  PersonDetailViewController.h
//  Communication
//
//  Created by helloworld on 15/7/23.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoModel.h"
@interface PersonDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
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
    UIButton * addBtn;
    
    NSArray * keys;
    BOOL isChange;
}
@property (strong,nonatomic) PersonInfoModel * model;
@property (strong,nonatomic)NSArray* _mutableArray;
@property (assign,nonatomic)NSInteger optionStatus;
@end
