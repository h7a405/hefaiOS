//
//  FYCustomerNeedsDao.m
//  HouseBank
//
//  Created by CSC on 14/12/3.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYCustomerNeedsDao.h"

#define KSearchHistoryPathForNeed [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/historyForNeed.plist"]

@implementation FYCustomerNeedsDao

-(NSArray *)searchHistoryForNeed{
    NSArray *data=[NSArray arrayWithContentsOfFile:KSearchHistoryPathForNeed];
    if (data==nil) {
        data=[NSArray array];
        [data writeToFile:KSearchHistoryPathForNeed atomically:YES];
    }
    
    return data;
}

-(void)saveHistoryForNeed:(NSDictionary *)community{
    NSArray *tmp=[NSArray arrayWithContentsOfFile:KSearchHistoryPathForNeed];
    
    NSMutableArray *data=[NSMutableArray arrayWithArray:tmp];
    if (data==nil) {
        data=[NSMutableArray array];
    }
    __block BOOL save=YES;
    
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict=obj;
        if ([[NSString stringWithFormat:@"%@",dict[@"communityId"]] isEqualToString:[NSString stringWithFormat:@"%@",community[@"communityId"]]]) {
            save=NO;
            *stop=YES;;
        }
    }];
    if (save) {
        
        [data addObject:community];
        [data writeToFile:KSearchHistoryPathForNeed atomically:YES];
        
    }
}

-(void)removeAllHistoryForNeed{
    NSArray *tmp=[NSArray arrayWithContentsOfFile:KSearchHistoryPathForNeed];
    NSMutableArray *data=[NSMutableArray arrayWithArray:tmp];
    if (data.count>0) {
        [data removeAllObjects];
        [data writeToFile:KSearchHistoryPathForNeed atomically:YES];
    }
}

@end
