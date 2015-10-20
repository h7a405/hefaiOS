//
//  CSBaseDao.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FYBaseDao.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
@implementation FYBaseDao

-(NSManagedObjectContext *)openDB{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *store = [(AppDelegate *)KAPPDelegate persistentStoreCoordinator];
        NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docs[0] stringByAppendingPathComponent:@"data.db"];
        NSLog(@"%@",path);
//        
//        NSURL *url = [NSURL fileURLWithPath:path];
//        NSError *error = nil;
//        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        if(store){
            sharedInstance=[[NSManagedObjectContext alloc] init];
            [sharedInstance setPersistentStoreCoordinator:store];
        }
    });
    
    return sharedInstance;
}

@end
