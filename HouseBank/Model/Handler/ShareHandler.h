//
//  ShareHandler.h
//  HouseBank
//
//  Created by CSC on 15/1/9.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareHandler : NSObject

+(void) shareApp;
+(void) shareWith : (NSString *) content url : (NSString *) url title : (NSString *) title;

@end
