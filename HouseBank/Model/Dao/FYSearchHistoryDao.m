//
//  FYSearchHistoryDao.m
//  HouseBank
//
//  Created by CSC on 14/12/2.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYSearchHistoryDao.h"

#define KSearchHistoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/history.plist"]

@implementation FYSearchHistoryDao

-(NSArray *)searchHistory{
    NSArray *data=[NSArray arrayWithContentsOfFile:KSearchHistoryPath];
    if (data==nil) {
        data=[NSArray array];
        [data writeToFile:KSearchHistoryPath atomically:YES];
    }
    
    return data;
}

-(void)saveHistory:(NSDictionary *)community{
    NSArray *tmp=[NSArray arrayWithContentsOfFile:KSearchHistoryPath];
    NSMutableArray *data=[NSMutableArray arrayWithArray:tmp];
    if (data==nil) {
        data=[NSMutableArray array];
    }
    __block BOOL save=YES;
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        if ([[NSString stringWithFormat:@"%@",dict[@"communityName"]] isEqualToString:[NSString stringWithFormat:@"%@",community[@"communityName"]]]) {
            save=NO;
            *stop=YES;;
        }
    }];
    
    if (save) {
        [data addObject:community];
        [data writeToFile:KSearchHistoryPath atomically:YES];
    }
}

-(void)removeAllHistory
{
    NSArray *tmp=[NSArray arrayWithContentsOfFile:KSearchHistoryPath];
    NSMutableArray *data=[NSMutableArray arrayWithArray:tmp];
    if (data.count>0) {
        [data removeAllObjects];
        [data writeToFile:KSearchHistoryPath atomically:YES];
    }
}

@end
