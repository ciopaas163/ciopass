//
//  Thecalendar.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicViewController.h"
@interface Thecalendar : UIViewController

{

    NSString*  startTimer;
    UIDatePicker* _datePicker;
    
    UIButton* _btnTimer;//导航栏上面的时间按钮
    
    NSString* _strTimer;//储存时间值
    
    UIView* dateView; //放置 UIDatePicker和 确定取消button
    
    UIButton* btncancel;//q取消

    UIButton* _btn;
}
@end
