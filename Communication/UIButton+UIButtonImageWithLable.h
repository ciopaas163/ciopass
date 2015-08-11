//
//  UIButton+UIButtonImageWithLable.h
//  Communication
//
//  Created by helloworld on 15/7/23.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end
