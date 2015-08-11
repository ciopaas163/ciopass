//
//  CalendarViewController.h
//  Communication
//
//  Created by helloworld on 15/7/27.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController
{
    UILabel * titleLab;
    UILabel * subLab;
    UIView * calenView;
    UIView * heardView;
    UIButton * monthBtn;
    UIButton * weekBtn;
    UIButton * todayBtn;
    UITableView * tableview;
    
    NSArray * dayArray;
    NSArray * weekArray;
    int strMonth;
    int strYear;
    NSString * strWeek;
    int firstWeekDayInmonth;
    int numberOfdaysInmonth;
    NSInteger currBtnTag;
    NSInteger mark;
    NSInteger startIndex;
    NSInteger endIndex;
    
    NSInteger status;
}
@end
