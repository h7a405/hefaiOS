//
//  FYAddressDao.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYAddressDao.h"

#define UploadCityTime @"time"

/**
 城市列表数据库操作类
 */
@implementation FYAddressDao

//保存城市列表
-(void) saveAddress : (NSArray *) data{
    NSManagedObjectContext * context = (NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    NSArray *tmp=[context executeFetchRequest:request error:nil];
    [tmp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [context deleteObject:obj];
    }];
    [context save:nil];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Address *address=[NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:context];
        NSDictionary *dict=obj;
        address.tid=dict[@"id"];
        address.name=dict[@"name"];
        address.pinyin=dict[@"pinyin"];
        address.py=dict[@"py"];
        address.sort=[NSString stringWithFormat:@"%@",dict[@"sort"]];
    }];
    [context save:nil];
}

//所有省份
-(NSArray *) allProvience{
    NSManagedObjectContext * context = (NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request.predicate=[NSPredicate predicateWithFormat:@"tid<100"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:YES];
    request.sortDescriptors=@[sort];
    NSArray *data=[context executeFetchRequest:request error:nil];
    return data;
}


-(void) saveUploadCityTime : (long) time{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setDouble: time forKey:UploadCityTime];
};

-(long) uploadCityTime{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    return [accountDefaults doubleForKey:UploadCityTime];
};

-(NSArray *)citysWithProvience:(Address *)provience{
    return [Address addressDataWithPid:[NSString stringWithFormat:@"%@",provience.tid]];
}

-(NSArray *)areasWithCity:(Address *)city{
    return [Address addressDataWithPid:[NSString stringWithFormat:@"%@",city.tid]];
}

-(NSArray *)streesWithArea:(Address *)area{
    return [Address addressDataWithPid:[NSString stringWithFormat:@"%@",area.tid]];
}

-(NSArray *)addressDataWithPid:(NSString *)pid{
    NSManagedObjectContext * context=(NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request.predicate=[NSPredicate predicateWithFormat:@"tid BETWEEN{%d,%d}",[pid integerValue]*100,([pid integerValue]+1)*100];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:YES];
    request.sortDescriptors=@[sort];
    NSArray *data=[context executeFetchRequest:request error:nil];
    return data;
}

-(NSArray *)addressByAId : (id) aid{
    NSManagedObjectContext * context=(NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request.predicate=[NSPredicate predicateWithFormat:@"tid = %@",aid];
    NSArray *data=[context executeFetchRequest:request error:nil];
    return data;
};

-(NSArray *)allCity{
    NSManagedObjectContext * context=(NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request.predicate=[NSPredicate predicateWithFormat:@"tid BETWEEN{%d,%d}",10*100,99*100];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:YES];
    request.sortDescriptors=@[sort];
    NSArray *data=[context executeFetchRequest:request error:nil];
    return data;
}
-(NSString *)addressWithRegionId:(NSString *)regionId{
    NSManagedObjectContext *context=(NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request.predicate=[NSPredicate predicateWithFormat:@"tid ==%@",regionId];
    NSArray *data=[context executeFetchRequest:request error:nil];
    NSString *reg=[[data firstObject]name];
    
    NSFetchRequest *request1=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request1.predicate=[NSPredicate predicateWithFormat:@"tid ==%@",[regionId substringToIndex:6]];
    
    NSArray *data1=[context executeFetchRequest:request1 error:nil];
    NSString *area=[[data1 firstObject]name];
    
    NSFetchRequest *request2=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request2.predicate=[NSPredicate predicateWithFormat:@"tid ==%@",[regionId substringToIndex:4]];
    NSArray *data2=[context executeFetchRequest:request2 error:nil];
    NSString *city=[[data2 firstObject]name];
    
    return [NSString stringWithFormat:@"%@ %@ %@",city,area,reg];
}

-(NSString *)addressIdWithCityName:(NSString *)name{
    NSManagedObjectContext *context=(NSManagedObjectContext *)[super openDB];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Address"];
    request.predicate=[NSPredicate predicateWithFormat:@"name ==%@",name];
    NSArray *data=[context executeFetchRequest:request error:nil];
    
    if (data.count==0) {
        return @"";
    }
    Address *address=[data firstObject];
    return [NSString stringWithFormat:@"%@",address.tid];
}

@end
