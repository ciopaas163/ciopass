//
//  CustomerController.h
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuclabelModel.h"
#import "CustomerModel.h"
@interface CustomerController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
{

    UITableView* _tableView;

    NSMutableArray* _mutableArray;
    NSMutableDictionary * _customerDict;
    //NSMutableArray * _topCustome;
    NSMutableDictionary * _showCusDict;
}
@property(strong, nonatomic)CuclabelModel* model;
@property(strong,nonatomic)CustomerModel * cusModel;
@property(assign,nonatomic)NSInteger optionStatus;
@end


