//
//  CKCalendarHeaderView.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarHeaderView.h"

#import "CKCalendarView.h"

#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height

@interface CKCalendarHeaderView ()
{
    UIButton *currentButton;
     CGFloat touViewH;
}

@property (nonatomic, strong) CKCalendarView *calendarView;

@end


int _columnTitleHeight =20;

@implementation CKCalendarHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self toubu];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)toubu
{
    CGFloat buttonY = 2;
    CGFloat buttonH = 0;
    CGFloat labelWidth = KSCREENWIDTH/7;
    CGFloat labelHeight = _columnTitleHeight;
    
    CGFloat labelY = buttonY;
    
    touViewH =labelY*2+labelHeight;
    
    UIView *touView = [[UIView alloc]initWithFrame:CGRectMake(0,0,KSCREENWIDTH, touViewH)];
    //    touView.layer.borderWidth = 1;
    
    [self addSubview:touView];
    

    
    NSArray *xingArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    for (NSUInteger i = 0; i < 7; i++)
    {
        NSString *title = xingArray[i];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth, labelY, labelWidth, labelHeight)];
        label.text = title;
        [label setTextAlignment:NSTextAlignmentCenter];
        
        if ([title isEqualToString:@"日"]||[title isEqualToString:@"六"])
        {
            [label setTextColor:[UIColor redColor]];
        }
        [touView addSubview:label];
    }
    
}

#warning mark 今、周 月 天 的点击






@end
