//
//  CusMarkViewController.h
//  Communication
//
//  Created by helloworld on 15/7/31.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusMarkViewController : UIViewController
{
    NSDictionary * dict;
    NSString * nid;
    UIView * firstView;
    UIView * secondView;
}
@property (strong,nonatomic)NSString * cid;
@property (assign,nonatomic)NSInteger saveStatus;
@property (strong,nonatomic)NSArray * customerArray;
@end
