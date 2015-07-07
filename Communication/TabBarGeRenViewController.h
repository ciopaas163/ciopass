//
//  TabBarGeRenViewController.h
//  Communication
//
//  Created by helloworld on 15/2/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarKit/CalendarKit.h"
@interface TabBarGeRenViewController : UITabBarController<UITableViewDelegate>

{
    UINavigationController* _nav1;
    UINavigationController *nav3;
    
}
@property (strong, nonatomic) CKCalendarViewController *viewController;
@end
