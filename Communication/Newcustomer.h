//
//  Newcustomer.h
//  Communication
//
//  Created by CIO on 15/2/10.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"
#import "JSONKit.h"
@interface Newcustomer : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableview;
    NSMutableArray * dataArray;
    NSArray * keys;
}
@property (strong,nonatomic)CustomerModel * model;
@property (assign,nonatomic)NSInteger status;
@end
