//
//  Database.h
//  Communication
//
//  Created by helloworld on 15/3/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
@interface Database : NSObject

//+ (Database *)shareDatabase;
+(Database*)sharDatabase;

- (BOOL)addMovie:(NSString *)sql;                     //添加数据

- (BOOL)deleteMovie:(NSString *)Schedule;       //删除某条数据

- (NSArray *)searchMovieByName:(NSString *)name;    //查询某一个

- (NSArray *)allSchedule;                          //查询所有

- (BOOL)updateMovie:(NSString *)sql;              //更新某条数据


- (FMResultSet*)searchCalendar:(NSString *)sql;  //日历操作记录

//- (BOOL)updateMovie:(ScheduleModel *)oldSchedule
//                new:(ScheduleModel *)newSchedule;
//获得存放数据库文件的沙盒地址
-(NSString*)databaseFilePath;
@property(strong,nonatomic)FMDatabase* datadb;
//创建数据库的操作
-(void)creatDatabase :(NSString *)sql;

//创建表
-(void)creatTable;

- (void)saveSql:(NSString *)sql;

- (FMResultSet *)readSql:(NSString *)sql;


@end
