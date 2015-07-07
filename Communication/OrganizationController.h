//
//  OrganizationController.h
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationController : UIViewController

{
    UITableView* _tableView;
    NSMutableArray* _organizationArray;
    
    NSMutableArray* _detailsMutableArray;

    NSString* _enTerpriseID;// 企业标签ID
    NSString* _employees;//企业员工departmentid 用来和企业标签进行判断的
    
    NSMutableArray* _iosMutableArray;//开发部
    NSMutableArray* _testMutableArrar;//测试部
    NSMutableArray* _marketMutableArray;//市场部
    NSMutableArray* _headquartersArray;//总部
    NSMutableArray* _textTeamArray;//测试小组
    NSMutableArray* _overseasArray;//海外部
    NSMutableArray* _huizhouArray;//惠州测试
    NSMutableArray* _shenzhenAyyay;//深圳分公司
    NSMutableArray* _administrationArray;//行政部
    NSMutableArray* _hrArray;//人事部
    
}

@property(nonatomic,strong)NSString* Number;

@end
