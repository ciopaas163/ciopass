//
//  PersonalViewController.h
//  Communication
//
//  Created by helloworld on 15/7/23.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfoModel.h"
@interface PersonalViewController : UIViewController

<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableDictionary * _personInfo;
    NSMutableArray * _dataArray;
    NSMutableDictionary * _showData;
    NSUserDefaults * _defaults;
    
    UITableView * _personTable;
    
}
@property (strong,nonatomic)PersonInfoModel * contact;
@property (strong,nonatomic)NSString * status;
@end
