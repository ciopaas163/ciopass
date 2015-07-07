//
//  CustomerController.h
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuclabelModel.h"
@interface CustomerController : UIViewController

<UITableViewDataSource,UITableViewDelegate>
{

    UITableView* _tableView;

    NSMutableArray* _mutableArray;
}
@property(strong, nonatomic)CuclabelModel* model;
@end
