//
//  pilst.m
//  Communication
//
//  Created by CIO on 15/3/3.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "pilst.h"

@implementation pilst

-(void)plistFangfa{
    //    建立文件管理
    NSFileManager * IDdata = [NSFileManager defaultManager];
    //    找到Documents文件所在的路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];

    //    把TestPlist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];

    //    开始创建文件
    [IDdata createFileAtPath:plistPath contents:nil attributes:nil];

    //    删除文件
    [IDdata removeItemAtPath:plistPath error:nil];

    //    在写入数据之前，需要把要写入的数据先写入一个字典中，创建一个dictionary：
    //    创建一个字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"zhangsan",@"1",@"lisi",@"2", nil];

    //    把数据写入plist文件
    [dic writeToFile:plistPath atomically:YES];

    //    读取plist文件，首先需要把plist文件读取到字典中
    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    //    打印数据
    NSLog(@"key1 is %@",[dic2 valueForKey:@"1"]);
    NSLog(@"dic is %@",dic2);
    //    关于plist中的array读写，代码如下：
    //    把TestPlist文件加入
    NSString *plistPaths = [filePath stringByAppendingPathComponent:@"tests.plist"];

    //    开始创建文件
    [IDdata createFileAtPath:plistPaths contents:nil attributes:nil];

    //    创建一个数组
    NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];

    //    写入
    [arr writeToFile:plistPaths atomically:YES];
    NSLog(@"arr:%@",arr);

    //    读取
    NSArray *arr1 = [NSArray arrayWithContentsOfFile:plistPaths];
    
    //    打印
    NSLog(@"arr1is %@",arr1);
}


@end
