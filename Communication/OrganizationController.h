//
//  OrganizationController.h
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

{
    UITableView* _tableView;
    NSMutableArray* _organizationArray;
    NSMutableArray * _topArray;
    NSMutableArray * _secondArray;
    NSMutableDictionary * _organizaTotalDict;
    NSMutableDictionary* _detailsMutableArray;
    NSMutableArray * backPid;
    //NSString* _enTerpriseID;// 企业标签ID
    NSMutableArray* _employees;//
    NSInteger dataStatus;
}

@property(nonatomic,strong)NSString* Number;

@end
