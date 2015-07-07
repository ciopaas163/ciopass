//
//  TextViewController.h
//  Communication
//
//  Created by CIO on 15/3/6.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UINavigationBar* _navBar;

    UINavigationItem* _navItem;
}
@end
