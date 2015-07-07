//
//  TabBarController.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarKit/CalendarKit.h"
@interface TabBarController : UITabBarController
{
    UINavigationController* _nav1;

}
@property (strong, nonatomic) CKCalendarViewController *viewController;
@end
