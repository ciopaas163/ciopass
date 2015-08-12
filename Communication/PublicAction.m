//
//  PublicAction.m
//  Communication
//
//  Created by helloworld on 15/7/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PublicAction.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "FMDatabase.h"
@implementation PublicAction

+(void)clearSearchBarcolor:(UISearchBar *)sender
{
    float deviceVersion=[UIDevice currentDevice].systemVersion.floatValue;
    for (UIView *view in sender.subviews) {
        // for before iOS7.0
        if (deviceVersion<7.0)
        {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [view removeFromSuperview];
                break;
            }
        }else
        {
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0)
            {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    
}

+(void)changeContactType:(NSDictionary *)sender
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=paths[0];
    path=[path stringByAppendingPathComponent:@"contacttype.plist"];
    NSMutableDictionary * types=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (types==nil) {
        types=[[NSMutableDictionary alloc]init];
    }
    for (NSString * key in sender.allKeys) {
        [types setObject:[sender objectForKey:key] forKey:key];
    }
    [types writeToFile:path atomically:YES];
    
}

+(void)tableViewCenter:(UITableView *)sender
{
    if ([sender respondsToSelector:@selector(setSeparatorInset:)]) {
        [sender setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([sender respondsToSelector:@selector(setLayoutMargins:)]) {
        //[sender setLayoutMargins: UIEdgeInsetsZero];
    }
    
}

+(void)dialTelephone:(NSDictionary *)dict
{
    

    NSString * _id=[dict objectForKey:@"_id"];
    NSString * verify=[dict objectForKey:@"verify"];
    NSString * eid=[dict objectForKey:@"eid"];
    NSString * userid=[dict objectForKey:@"userid"];
    NSString * caller=[dict objectForKey:@"number"];
    NSString * callees=[dict objectForKey:@"callNum"];
    NSString * belong=[self getTelephoneLocation:caller];
    //open.ciopaas.com/Admin/Info/get_personal_data?id=1&verify=Z3V2XZF0
    NSDictionary * telDict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:belong,callees,caller,@"",userid, nil] forKeys:[NSArray arrayWithObjects:@"belong",@"callees",@"caller",@"callerName",@"userId", nil]];
    
    NSDictionary * datalist=[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:telDict] forKey:@"DataList"];
    NSString * path=[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/dial_payment_telephone?id=%@&verify=%@&eid=%@&userid=%@&from=2&telephonenumber=%@",_id,verify,eid,userid,[datalist JSONString]];
    
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSError * error;
   [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
}

+(NSString *)getTelephoneLocation:(NSString *)number
{
    NSString * path=[[NSBundle mainBundle] pathForResource:@"gecode" ofType:@"db"];
    FMDatabase * db=[FMDatabase databaseWithPath:path];
    NSMutableString * str=[NSMutableString stringWithFormat:@""];
    NSRange range={0,1};
    NSString * queryStr=[number substringWithRange:range];
    if ([queryStr isEqualToString:@"0"])
    {
        NSRange range2={1,1};
        NSInteger num=[[number substringWithRange:range2] integerValue];
        if (num<3) {
            NSRange range3={0,3};
            queryStr=[number substringWithRange:range3];
        }else
        {
            NSRange range4={0,4};
            queryStr=[number substringWithRange:range4];
        }
    }else
    {
        NSRange range5={0,7};
        queryStr=[number substringWithRange:range5];
    }
    if ([db open])
    {
        NSString * sql=[NSString stringWithFormat:@"select province,city,number from gecode where number=?"];
        FMResultSet * set=[db executeQuery:sql,queryStr];
        if ([set next]) {
            NSString * province=[set objectForColumnName:@"province"];
            NSString * city=[set objectForColumnName:@"city"];
            [str appendFormat:@"%@",province];
            if ([province isEqualToString:city])
            {
                return str;
            }else
            {
                [str appendFormat:@" %@",city];
                return str;
            }
        }
    }
    return  str;
}
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
