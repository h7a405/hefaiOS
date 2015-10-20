//
//  XSNotification.h
//  HouseBank
//
//  Created by 鹰眼 on 14/10/21.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XSNotification : NSManagedObject
/**
 *   订阅
 *  public static final int NOTICE_SUBSCRIPTION_TYPE = 1;
 //人脉
 public static final int NOTICE_CONTACT_TYPE = 2;
 //合作
 public static final int NOTICE_COOPERATION_HOUSE_TYPE = 3;
 //营销
 public static final int NOTICE_SYSTEM_MARKING_TYPE = 4;
 //默认
 public static final int NOTICE_NOMAL_TYPE = 0;
 */
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * brokerId;
/**
 *  保存推送过来的信息
 *
 *  @param dict
 *
 *  @return
 */
+(BOOL)notificationWithDict:(NSDictionary *)dict;
/**
 *  所有消息
 *
 *  @return
 */
+(NSArray *)allNotification;
/**
 *  清理所有消息
 */
+(void)cleanAllNotification;
@end
