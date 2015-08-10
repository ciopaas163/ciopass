//
//  MyInfoViewController.h
//  Communication
//
//  Created by helloworld on 15/7/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * sections;
    NSDictionary * tableData;
}
@end
