//
//  ScheduleModel.h
//  Communication
//
//  Created by helloworld on 15/3/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleModel : NSObject


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *loginID;
@property (nonatomic, strong) NSString *operateId;
@property (nonatomic, strong) NSString *sysID;
@property (nonatomic, strong) NSString *stop_time;
@property (nonatomic, strong) NSString *alertTime;
@property (nonatomic, strong) NSString *begin_time;
@property (nonatomic, strong) NSString *task_tag;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *SID;
@property (nonatomic, strong) NSString *verify;


@end
