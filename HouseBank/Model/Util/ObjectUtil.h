//
//  ObjectUtil.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectUtil : NSObject

/**
 将一个字典对象转化成一个实体类对象
 */
+(id) objFromDic : (NSDictionary *) dic obj:(id) obj;

/**
 将一个实体类对象转化成一个字典
 */
+(id) object2Dictionary:(id)obj;

+(id) replaceNil :(id) replace ;
@end
