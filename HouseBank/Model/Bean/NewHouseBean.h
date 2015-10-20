//
//  BaseClass.h
//
//  Created by   on 14-9-23
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewHouseBean : NSObject
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *commissionRate;
@property (nonatomic, strong) NSURL *imagePath;
@property (nonatomic, copy) NSString  *lowestPrice;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *highestPrice;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *totleHouse;
@property (nonatomic, copy) NSString *title ;
@property (nonatomic, copy) NSString *address ;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
