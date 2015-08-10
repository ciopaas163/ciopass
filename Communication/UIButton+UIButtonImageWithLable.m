//
//  UIButton+UIButtonImageWithLable.m
//  Communication
//
//  Created by helloworld on 15/7/23.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "UIButton+UIButtonImageWithLable.h"

@implementation UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    //CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16]];
    [self.imageView setContentMode:UIViewContentModeLeft];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,
                                              -40.0,
                                              0.0,
                                              10.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeLeft];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
   // [self.titleLabel setFont:HELVETICANEUEMEDIUM_FONT(12.0f)];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                              -40.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}
/*
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithFont:HELVETICANEUEMEDIUM_FONT(12.0f)];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              0.0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:HELVETICANEUEMEDIUM_FONT(12.0f)];
    [self.titleLabel setTextColor:COLOR_ffffff];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              0.0,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}*/
@end
