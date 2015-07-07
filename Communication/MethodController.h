//
//  MethodController.h
//  Communication
//
//  Created by CIO on 15/2/3.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MethodController : UIViewController


+(MethodController *)sharedpupsviewcontroller;

-(void)leftButton:(UIBarButtonItem*)click;  //导航栏左边的按钮;

-(void)rightButton:(UIBarButtonItem*)click; //导航栏右边的按钮;




@end
