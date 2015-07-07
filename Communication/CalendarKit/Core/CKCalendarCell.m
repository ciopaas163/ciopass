
//
//  CKCalendarCalendarCell.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellColors.h"

#import "UIView+Border.h"

#import "LunarCalendar.h"   //农历日期
#import "CYDatetime.h"

@interface CKCalendarCell (){
    CGSize _size;
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *nonglable;
@property (nonatomic, strong) UIView *dot;

@end

@implementation CKCalendarCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _state = CKCalendarMonthCellStateNormal;
        
        //  Normal Cell Colors
        _normalBackgroundColor = [UIColor whiteColor];
        _selectedBackgroundColor = kCalendarColorBlue;
        _inactiveSelectedBackgroundColor = kCalendarColorDarkGray;
        
        //  Today Cell Colors
        _todayBackgroundColor = kCalendarColorBluishGray;
        _todaySelectedBackgroundColor = kCalendarColorBlue;
        _todayTextShadowColor = kCalendarColorTodayShadowBlue;
        _todayTextColor = [UIColor whiteColor];
        
        //  Text Colors
        _textColor = kCalendarColorDarkTextGradient;
        _textShadowColor = [UIColor whiteColor];
        _textSelectedColor = [UIColor whiteColor];
        _textSelectedShadowColor = kCalendarColorSelectedShadowBlue;
        
        _dotColor = kCalendarColorDarkTextGradient;
        _selectedDotColor = [UIColor whiteColor];
        
        _cellBorderColor = kCalendarColorCellBorder;
        _selectedCellBorderColor = kCalendarColorSelectedCellBorder;
        
        // Label
        _label = [UILabel new];
        
        //农历
        _nonglable = [UILabel new];
        
        //  Dot
        _dot = [UIView new];
        [_dot setHidden:YES];
        _showDot = NO;
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [self init];
    if (self) {
        _size = size;
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, _size.width, _size.height)];
    [self layoutSubviews];
    [self applyColors];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self configureLabel];
    [self configureDot];
    
    [self addSubview:[self label]];
    
    [self addSubview:[self nonglable]];  //添加农历
    
    [self addSubview:[self dot]];        //添加点
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.label.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    self.nonglable.frame = CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame));
}


- (void)setState:(CKCalendarMonthCellState)state
{
    if (state > CKCalendarMonthCellStateOutOfRange || state < CKCalendarMonthCellStateTodaySelected) {
        return;
    }
    
    _state = state;
    
    [self applyColorsForState:_state];
}

- (void)setNumberMonth:(NSNumber *)numberMonth
{
    _numberMonth = numberMonth;
}
- (void)setNumberYear:(NSNumber *)numberYear
{
    _numberYear = numberYear;
}

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    
    //  TODO: Locale support?
    NSString *stringVal = [number stringValue];
    [[self label] setText:stringVal];
    
    CYDatetime *CYDate = [[CYDatetime alloc]init];
    
    CYDate.year=[_numberYear integerValue];
    CYDate.month =[_numberMonth integerValue];
    
    CYDate.day = [number integerValue];
    
    LunarCalendar *lunarCalendar = [[CYDate convertDate] chineseCalendarDate ];
    NSString * lunarDate = [lunarCalendar.DayLunar isEqualToString:@"初一"]?lunarCalendar.MonthLunar :[[NSString alloc]initWithFormat:
                                                                                                     @"%@",[lunarCalendar.SolarTermTitle isEqualToString:@""]?lunarCalendar.DayLunar:lunarCalendar.SolarTermTitle];
    [[self nonglable] setText:lunarDate];
}

- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    [[self dot] setHidden:!showDot];
}

#pragma mark - Recycling Behavior

-(void)prepareForReuse
{
    //  Alpha, by default, is 1.0
    [[self label]setAlpha:1.0];
    
    [self setState:CKCalendarMonthCellStateNormal];
    
    [self applyColors];
}

#pragma mark - Label 

- (void)configureLabel
{
    UILabel *label = [self label];
    
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFrame:CGRectMake(0, 5, [self frame].size.width, 20)];
    
    UILabel *nonglabel = [self nonglable];
    
    [nonglabel setFont:[UIFont boldSystemFontOfSize:10]];
    [nonglabel setTextAlignment:NSTextAlignmentCenter];
    
    [nonglabel setBackgroundColor:[UIColor clearColor]];
    [nonglabel setFrame:CGRectMake(0, 25, [self frame].size.width, 12)];
}

#pragma mark - Dot 点

- (void)configureDot
{
    UIView *dot = [self dot];
    
    CGFloat dotRadius = 5;
    CGFloat selfHeight = [self frame].size.height;
    CGFloat selfWidth = [self frame].size.width;
    
    [[dot layer] setCornerRadius:dotRadius/2];
    
    CGRect dotFrame = CGRectMake(selfWidth/2 - dotRadius/2, (selfHeight - (selfHeight/5)) - dotRadius/2, dotRadius, dotRadius);
    [[self dot] setFrame:dotFrame];
    
}

#pragma mark - UI Coloring

- (void)applyColors
{    
    [self applyColorsForState:[self state]];
    [self showBorder];
}

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCalendarMonthCellState)state
{
    //  Default colors and shadows
    [[self label] setTextColor:[self textColor]];
    [[self label] setShadowColor:[self textShadowColor]];
    [[self label] setShadowOffset:CGSizeMake(0, 0.5)];
    
    [[self nonglable] setTextColor:[self textColor]];
    [[self nonglable] setShadowColor:[self textShadowColor]];
    [[self nonglable] setShadowOffset:CGSizeMake(0, 0.5)];
    
    [self setBorderColor:[self cellBorderColor]];
    [self setBorderWidth:0.5];
    [self setBackgroundColor:[self normalBackgroundColor]];
    
    //  Today cell
    if(state == CKCalendarMonthCellStateTodaySelected)
    {
        [self setBackgroundColor:[self todaySelectedBackgroundColor]];
        [[self label] setShadowColor:[self todayTextShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
        [[self nonglable] setShadowColor:[self todayTextShadowColor]];
        [[self nonglable] setTextColor:[self todayTextColor]];

        [self setBorderColor:[self backgroundColor]];
    }
    
    //  Today cell, selected
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
        [self setBackgroundColor:[self todayBackgroundColor]];
        [[self label] setShadowColor:[self todayTextShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
        [[self nonglable] setShadowColor:[self todayTextShadowColor]];
        [[self nonglable] setTextColor:[self todayTextColor]];

        [self setBorderColor:[self backgroundColor]];
        [self showBorder];
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarMonthCellStateSelected)
    {
        [self setBackgroundColor:[self selectedBackgroundColor]];
        [self setBorderColor:[self selectedCellBorderColor]];
        [[self label] setTextColor:[self textSelectedColor]];
        [[self label] setShadowColor:[self textSelectedShadowColor]];
        [[self label] setShadowOffset:CGSizeMake(0, -0.5)];
        
        [[self nonglable] setTextColor:[self textSelectedColor]];
        [[self nonglable] setShadowColor:[self textSelectedShadowColor]];
        [[self nonglable] setShadowOffset:CGSizeMake(0, -0.5)];

    }
    
    if (state == CKCalendarMonthCellStateInactive) {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
        
        [[self nonglable] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self nonglable] setShadowOffset:CGSizeZero];

    }
    else if (state == CKCalendarMonthCellStateInactiveSelected)
    {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
        
        [[self nonglable] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self nonglable] setShadowOffset:CGSizeZero];

        [self setBackgroundColor:[self inactiveSelectedBackgroundColor]];
    }
    else if(state == CKCalendarMonthCellStateOutOfRange)
    {
        [[self label] setAlpha:0.01];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
        
        [[self nonglable] setAlpha:0.01];    //  Label alpha needs to be lowered
        [[self nonglable] setShadowOffset:CGSizeZero];

    }
    
    //  Make the dot follow the label's style
    [[self dot] setBackgroundColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    [[self dot] setAlpha:[[self label] alpha]];
}

#pragma mark - Selection State

- (void)setSelected
{
    
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactive) {
        [self setState:CKCalendarMonthCellStateInactiveSelected];
    }
    else if(state == CKCalendarMonthCellStateNormal)
    {
        [self setState:CKCalendarMonthCellStateSelected];
    }
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
        [self setState:CKCalendarMonthCellStateTodaySelected];
    }
}

- (void)setDeselected
{
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactiveSelected) {
        [self setState:CKCalendarMonthCellStateInactive];
    }
    else if(state == CKCalendarMonthCellStateSelected)
    {
        [self setState:CKCalendarMonthCellStateNormal];
    }
    else if(state == CKCalendarMonthCellStateTodaySelected)
    {
        [self setState:CKCalendarMonthCellStateTodayDeselected];
    }
}

- (void)setOutOfRange
{
    [self setState:CKCalendarMonthCellStateOutOfRange];
}

@end
