//
//  PublicAction.h
//  Communication
//
//  Created by helloworld on 15/7/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PublicAction : NSObject
+(void)clearSearchBarcolor:(UISearchBar *)sender;
+(void)tableViewCenter:(UITableView *)sender;
+(void)dialTelephone:(NSDictionary *)dict;
+(NSString *)getTelephoneLocation:(NSString *)number;
+(UIColor *) randomColor;
+(void)changeContactType:(NSDictionary *)sender;
@end
