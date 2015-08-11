//
//  PersonInfoViewController.h
//  Communication
//
//  Created by helloworld on 15/7/20.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationModel.h"
@interface PersonInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableview;
    NSMutableArray * dataArray;
}
@property (strong,nonatomic)OrganizationModel * model;
@end