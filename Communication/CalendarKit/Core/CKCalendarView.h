//
//  CKCalendarCalendarView.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarHeaderView.h"
#import "CKCalendarViewModes.h"

#import "CKCalendarEvent.h"

#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"

@interface CKCalendarView : UIView
{
       NSString *_titleHeader;
}
@property(nonatomic,copy) NSString *titleHeader;

@property (nonatomic, assign) CKCalendarDisplayMode displayMode;

@property(nonatomic, strong) NSLocale       *locale;            // default is [NSLocale currentLocale]. setting nil returns to default
@property(nonatomic, copy)   NSCalendar     *calendar;          // default is [NSCalendar currentCalendar]. setting nil returns to default
@property(nonatomic, strong) NSTimeZone     *timeZone;          // default is nil. use current time zone or time zone from calendar

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, assign) NSUInteger firstWeekDay;  //  Proxies to the calendar's firstWeekDay so we can update the UI immediately  代理日历的firstweekday所以我们可以立即更新UI.

@property (nonatomic, weak) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, weak) id<CKCalendarViewDelegate> delegate;

+(CKCalendarView*)sharDatabase;


/* Initializer */

- (instancetype)init;
- (instancetype)initWithMode:(CKCalendarDisplayMode)CalendarDisplayMode;

/* Reload calendar and events  重装日历和事件. */

- (void)reload;
- (void)reloadAnimated:(BOOL)animated;

/* Setters */

- (void)setCalendar:(NSCalendar *)calendar;
- (void)setCalendar:(NSCalendar *)calendar animated:(BOOL)animated;

- (void)setDate:(NSDate *)date;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode;
- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode animated:(BOOL)animated;

- (void)setLocale:(NSLocale *)locale;
- (void)setLocale:(NSLocale *)locale animated:(BOOL)animated;

- (void)setTimeZone:(NSTimeZone *)timeZone;
- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated;

- (void)setMinimumDate:(NSDate *)minimumDate;
- (void)setMinimumDate:(NSDate *)minimumDate animated:(BOOL)animated;

- (void)setMaximumDate:(NSDate *)maximumDate;
- (void)setMaximumDate:(NSDate *)maximumDate animated:(BOOL)animated;

/* Visible Dates  可见日期*/

- (NSDate *)firstVisibleDate;
- (NSDate *)lastVisibleDate;

- (void)backwardTapped;
- (void)forwardTapped;

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header;

@end
