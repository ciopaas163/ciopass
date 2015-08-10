//
//  UsercontactGroup.h
//  Communication
//
//  Created by helloworld on 15/8/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsercontactGroup : UIViewController
{
    NSMutableDictionary * dict;
    NSString * nid;
    UIView * firstView;
    UIView * secondView;
}
@property (strong,nonatomic)NSString * cid;
@property (strong,nonatomic)NSArray * customerArray;
@end
