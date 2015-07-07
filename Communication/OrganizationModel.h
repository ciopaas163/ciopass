//
//  OrganizationModel.h
//  Communication
//
//  Created by CIO on 15/3/4.
//  Copyright (c) 2015年 JL. All rights reserved.
//


#pragma mark  [  组织构架]

#import <Foundation/Foundation.h>

@interface OrganizationModel : NSObject

//组织构架标签
@property (nonatomic, strong) NSString *_id; //
@property (nonatomic, strong) NSString *pid;   //级别ID
@property (nonatomic, strong) NSString *departmentname; // 部门名称
@property (nonatomic, strong) NSString *eid;            //企业ID
@property (nonatomic, strong) NSString *ctime;          //时间

//开发部
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *departmentid;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *telephone1;
@property (nonatomic, strong) NSString *telephone2;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSString *ciocaasUserID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *ctimes;


@end
