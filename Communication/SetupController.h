//
//  SetupController.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
@interface SetupController : UIViewController


<UITableViewDataSource,UITableViewDelegate,QRadioButtonDelegate>


{
    
      UITableView*  _tableView;
}
@end
