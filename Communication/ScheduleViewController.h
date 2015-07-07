//
//  ScheduleViewController.h
//  Communication
//
//  Created by helloworld on 15/2/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
@interface ScheduleViewController : UIViewController<QRadioButtonDelegate>

{
    UIButton* _btnTimer;//导航栏上面的时间按钮
    
    NSString* _strTimer;//储存时间值
    
    UIView* dateView; //放置 UIDatePicker和 确定取消button
    
    UIButton* btncancel;//q取消
    
    UIDatePicker* _datePicker;
    
}

@property (nonatomic,copy) NSString *sysID;
@end
