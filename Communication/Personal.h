//
//  Personal.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicViewController.h"

@protocol CommunicationDelegate;

@interface Personal : PublicViewController

<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSString* biaoqian;

@property(strong,nonatomic)NSString * needPhone;

@property(strong,nonatomic)id<CommunicationDelegate>Commundelegate;

@end

@protocol CommunicationDelegate <NSObject>

-(void)Transferlabel:(NSString*)labelName;

@end


