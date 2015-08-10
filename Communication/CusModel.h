//
//  CusModel.h
//  Communication
//
//  Created by CIO on 15/3/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CusModel : NSObject


@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *groupname;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, assign) NSInteger status;


@end
