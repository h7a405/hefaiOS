//
//  ViewController.h
//  客需
//
//  Created by JunJun on 14/12/29.
//  Copyright (c) 2014年 JunJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXBaseModel : NSObject <NSCoding>{

}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;

- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
